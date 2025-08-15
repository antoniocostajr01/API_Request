//
//  servies.swift
//  API Resquet
//
//  Created by sofia leitao on 15/08/25.
//
import Foundation

protocol APIServicing {
    func fetchProducts() async throws -> [Product]
    func fetchCategories() async throws -> [Category]
}

struct DummyJSONService: APIServicing {
    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else {
            throw URLError(.badURL)
        }
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Category].self, from: data)
    }
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw URLError(.badURL)
        }

        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ProductsResponse.self, from: data).products
    }
}
