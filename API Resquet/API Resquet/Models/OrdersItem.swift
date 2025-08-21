//
//  OrdersItem.swift
//  API Resquet
//
//  Created by sofia leitao on 20/08/25.
//

import Foundation
import SwiftUI

final class OrdersItem: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var createdAt: Date? = nil

    func save(from cart: CartStore, limit: Int? = nil) {
        let sorted = cart.items.values.sorted { $0.id < $1.id }
        let slice = limit.map { Array(sorted.prefix($0)) } ?? sorted
        self.items = slice
        self.createdAt = Date()
    }

    func save(items: [CartItem]) {
        self.items = items
        self.createdAt = Date()
    }

    func clear() {
        items.removeAll()
        createdAt = nil
    }
}
