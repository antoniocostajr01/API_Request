//
//  models.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import Foundation

struct ProductsResponse: Decodable {
    let products: [Product]
}

struct Product: Identifiable, Decodable {
    let id: Int
    let title: String
    let description: String?
    let category: String
    let price: Double
    let brand: String?
    let thumbnail: String?
}


