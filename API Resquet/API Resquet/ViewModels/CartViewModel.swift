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
    
    private let dataSource: CartSwiftDataSerive
    private let service: APIServicing
    
    init(dataSource: CartSwiftDataSerive, service: APIServicing ) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func loadPersistence() async {
        print("CartService shared instance: \(CartSwiftDataSerive.shared)")
        isLoading = true
        let persistedItems = dataSource.fetchProducts()
        
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
        if let existing = items[product.id] {
            var updated = existing
            updated.quantity += step
            items[product.id] = updated
            dataSource.updateProduct(id: product.id, quantity: updated.quantity)
        } else {
            let newItem = CartItem(product: product, quantity: step)
            items[product.id] = newItem
            dataSource.addProduct(item: CartPersistence(id: product.id, quantity: step))
        }
        
        Task { await loadPersistence() }
    }
    
    func increment(_ productId: Int) {
        guard var item = items[productId] else { return }
        item.quantity += 1
        items[productId] = item
    }
    
    func decrement(_ productId: Int) {
        guard var item = items[productId] else { return }
        item.quantity = max(0, item.quantity - 1)
        if item.quantity == 0 { items.removeValue(forKey: productId) }
        else { items[productId] = item }
    }
    
    func binding(for product: Product) -> Binding<Int> {
        Binding(
            get: { self.items[product.id]?.quantity ?? 0 },
            set: { newValue in
                if newValue <= 0 {
                    self.items.removeValue(forKey: product.id)
                } else if var existing = self.items[product.id] {
                    existing.quantity = newValue
                    self.items[product.id] = existing
                } else {
                    self.items[product.id] = CartItem(product: product, quantity: newValue)
                }
            }
        )
    }
    func clear(keepingCapacity: Bool = false) {
        items.removeAll(keepingCapacity: keepingCapacity)
        
    }
    
    func removeProduct(by id: Int) {
        items.removeValue(forKey: id)
        dataSource.deleteProduct(id: id)
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
