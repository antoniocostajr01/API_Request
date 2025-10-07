//
//  ProductModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 19/08/25.
//

import Foundation

final class ProductModel{
    let id = UUID()
    let title: String
    let description: String?
    let category: String
    let price: Double
    let thumbnail: String?
    
    init(title: String, description: String?, category: String, price: Double, thumbnail: String?) {
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.thumbnail = thumbnail
    }
}
