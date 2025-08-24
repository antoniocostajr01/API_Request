//
//  CartItem.swift
//  API Resquet
//
//  Created by sofia leitao on 19/08/25.
//
import SwiftUI
import SwiftData


@Model
class CartItem: Identifiable {
    var id: Int
//    let product: Product
    var quantity: Int
    
    init(id: Int ,quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
}

class CartStore: ObservableObject {
    @Published private(set) var items: [Int: CartItem] = [:]
    
    private let dataSource: SwiftDataService
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        
        let persisted = dataSource.fetchCart()
        
        self.items = Dictionary(uniqueKeysWithValues: persisted.map { ($0.id, $0) })
    }
    
    func add(productId: Int, step: Int = 1) {
        if let existing = items[productId] {
            existing.quantity += step
            items[productId] = existing
            dataSource.updateCartQuantity(product: existing, newQuantity: existing.quantity) // ⬅️ persistência
        } else {
            let newItem = CartItem(id: productId, quantity: step)
            items[productId] = newItem
            dataSource.addProductToCart(product: newItem) // ⬅️ persistência
        }
    }
    
    func increment(_ productId: Int) {
        guard let item = items[productId] else { return }
        item.quantity += 1
        items[productId] = item
        dataSource.updateCartQuantity(product: item, newQuantity: item.quantity)
    }
    
    func decrement(_ productId: Int) {
        guard let item = items[productId] else { return }
        item.quantity -= 1
        if item.quantity <= 0 {
            items.removeValue(forKey: productId)
            dataSource.deleteProductFromCart(product: item)
        } else {
            items[productId] = item
            dataSource.updateCartQuantity(product: item, newQuantity: item.quantity)
        }
    }
    
    func binding(for productId: Int) -> Binding<Int> {
        Binding(
            get: { self.items[productId]?.quantity ?? 0 },
            set: { newValue in
                if newValue <= 0 {
                    self.items.removeValue(forKey: productId)
                } else if let existing = self.items[productId] {
                    existing.quantity = newValue
                    self.items[productId] = existing
                } else {
                    self.items[productId] = CartItem(id: productId, quantity: newValue)
                }
            }
        )
    }
    
    func clear(keepingCapacity: Bool = false) {
        for item in items.values {
            dataSource.deleteProductFromCart(product: item)
        }
        items.removeAll(keepingCapacity: keepingCapacity)
    }
    
    func removeProduct(by id: Int) {
        items.removeValue(forKey: id)
    }

}

extension CartStore {
    var totalItems: Int {
        items.values.reduce(0) { $0 + $1.quantity }
    }
    
    func subtotal(using products: [Int: Product]) -> Double {
        items.values.reduce(0) { total, item in
            if let product = products[item.id] {
                return total + (Double(item.quantity) * product.price)
            }
            return total
        }
    }
}

