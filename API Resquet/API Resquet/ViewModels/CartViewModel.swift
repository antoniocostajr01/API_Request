//
//  CartViewModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 23/08/25.
//

import Foundation
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {
    @Published private(set) var items: [Int: CartItem] = [:]
    @Published var persistenceItems: [CartPersistence] = []
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    
    private let dataSource: SwiftDataService
    private let service: APIServicing
    
    init(dataSource: SwiftDataService, service: APIServicing ) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func loadPersistence() async {
        print("CartService shared instance: \(SwiftDataService.shared)")
        isLoading = true
        let persistedItems = dataSource.fetchCart()
        
        var loadedItems: [Int: CartItem] = [:]
        
        for item in persistedItems {
            if let product = try? await service.fetchProductById(id: item.id) {
                loadedItems[item.id] = CartItem(product: product, quantity: item.quantity)
            }
        }
        
        self.items = loadedItems
        isLoading = false
    }
    
    
    func add(_ product: Product, step: Int = 1) {
        // tenta buscar no persistence se já existe
        if let existingPersistence = dataSource.fetchCart().first(where: { $0.id == product.id }) {
            // atualiza a quantidade direto no persistence
            let newQuantity = existingPersistence.quantity + step
            dataSource.updateCartQuantity(product: existingPersistence, newQuantity: newQuantity)
            
            // atualiza também em memória
            if var existing = items[product.id] {
                existing.quantity = newQuantity
                items[product.id] = existing
            }
        } else {
            // cria no persistence
            let newPersistence = CartPersistence(id: product.id, quantity: step)
            dataSource.addProductToCart(product: newPersistence)
            
            // cria em memória
            let newItem = CartItem(product: product, quantity: step)
            items[product.id] = newItem
        }
        
        Task { await loadPersistence() }
    }
    
    func increment(_ productId: Int) {
        guard var item = items[productId] else { return }
        item.quantity += 1
        items[productId] = item
        
        if let persistence = dataSource.fetchCart().first(where: { $0.id == productId }) {
            dataSource.updateCartQuantity(product: persistence, newQuantity: item.quantity)
        }
    }
    
    func decrement(_ productId: Int) {
        guard var item = items[productId] else { return }
        item.quantity = max(0, item.quantity - 1)
        
        if item.quantity == 0 {
            items.removeValue(forKey: productId)
            if let persistence = dataSource.fetchCart().first(where: { $0.id == productId }) {
                dataSource.deleteProductFromCart(product: persistence)
            }
        } else {
            items[productId] = item
            if let persistence = dataSource.fetchCart().first(where: { $0.id == productId }) {
                dataSource.updateCartQuantity(product: persistence, newQuantity: item.quantity)
            }
        }
    }
    
    func binding(for product: Product) -> Binding<Int> {
        Binding(
            get: { self.items[product.id]?.quantity ?? 0 },
            set: { newValue in
                if newValue <= 0 {
                    self.items.removeValue(forKey: product.id)
                    if let persistence = self.dataSource.fetchCart().first(where: { $0.id == product.id }) {
                        self.dataSource.deleteProductFromCart(product: persistence)
                    }
                } else if var existing = self.items[product.id] {
                    existing.quantity = newValue
                    self.items[product.id] = existing
                    if let persistence = self.dataSource.fetchCart().first(where: { $0.id == product.id }) {
                        self.dataSource.updateCartQuantity(product: persistence, newQuantity: newValue)
                    }
                } else {
                    self.items[product.id] = CartItem(product: product, quantity: newValue)
                    let persistence = CartPersistence(id: product.id, quantity: newValue)
                    self.dataSource.addProductToCart(product: persistence)
                }
            }
        )
    }
    
    func clear(keepingCapacity: Bool = false) {
        items.removeAll(keepingCapacity: keepingCapacity)
        
        for persistence in dataSource.fetchCart() {
            dataSource.deleteProductFromCart(product: persistence)
        }
        
    }
    
    func removeProduct(by id: Int) {
        items.removeValue(forKey: id)
        
        if let persistence = dataSource.fetchCart().first(where: { $0.id == id }) {
            dataSource.deleteProductFromCart(product: persistence)
            
        }
    }
}

extension CartViewModel {
    var totalItems: Int {
        items.values.reduce(0) { $0 + $1.quantity }
    }
    var subtotal: Double {
        items.values.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) }
    }
}
