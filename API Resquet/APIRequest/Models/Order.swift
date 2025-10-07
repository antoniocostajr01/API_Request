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
    var amount: Double
    var date: Date
    
    init(id: Int, amount: Double, date: Date) {
        self.id = id
        self.amount = amount
        self.date = date
    }
}
