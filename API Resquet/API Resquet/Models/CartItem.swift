//
//  CartItem.swift
//  API Resquet
//
//  Created by sofia leitao on 19/08/25.
//
import SwiftUI

struct CartItem: Identifiable {
    let id: Int
    let product: Product
    var quantity: Int
    init(product: Product, quantity: Int) {
        self.id = product.id
        self.product = product
        self.quantity = quantity
    }
}

final class CartStore: ObservableObject {
    @Published private(set) var items: [Int: CartItem] = [:]
    
    func add(_ product: Product, step: Int = 1) {
        if let existing = items[product.id] {
            var updated = existing
            updated.quantity += step
            items[product.id] = updated
        } else {
            items[product.id] = CartItem(product: product, quantity: step)
        }
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
}

extension CartStore {
    var totalItems: Int {
        items.values.reduce(0) { $0 + $1.quantity }
    }
    var subtotal: Double {
        items.values.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) }
    }
}

