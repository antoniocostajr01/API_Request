//
//  CartItem.swift
//  API Resquet
//
//  Created by sofia leitao on 19/08/25.
//
 import Foundation


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

