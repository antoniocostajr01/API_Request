//
//  models.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import Foundation

struct ProductsResponse: Decodable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Identifiable, Decodable {
    let id: Int
    let title: String
    let description: String?
    let category: String
    let price: Double
    let discountPercentage: Double?
    let rating: Double?
    let brand: String?
    let thumbnail: String?
    let images: [String]?
}

