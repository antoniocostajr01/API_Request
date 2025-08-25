//
//  Order.swift
//  API Resquet
//
//  Created by Antonio Costa on 25/08/25.
//

import Foundation
import SwiftData

@Model
class Order {
    var id: Int
    var amount: Int
    
    init(id: Int, amount: Int) {
        self.id = id
        self.amount = amount
    }
}
