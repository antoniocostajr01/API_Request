//
//  CartPersistence.swift
//  API Resquet
//
//  Created by Antonio Costa on 24/08/25.
//

import Foundation
import SwiftData

@Model
class CartPersistence {
    var id: Int
    var quantity: Int
    
    init(id: Int, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
}
