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
    func fetchProductsByCategory(forCategory categoryName: String) async throws -> [Product]
    func fetchProductById(id: Int) async throws -> Product
}

struct DummyJSONService: APIServicing {
    
    let baseURL: String = "https://dummyjson.com"
    
    func fetchProductsByCategory(forCategory categoryName: String) async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products/category/\(categoryName.lowercased())") else {
            throw URLError(.badURL)
        }
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let structResponse = try decoder.decode(ProductsResponse.self, from: data)
        return structResponse.products
    }
    
    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "\(baseURL)/products/categories") else {
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
        guard let url = URL(string: "\(baseURL)/products") else {
            throw URLError(.badURL)
        }

        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ProductsResponse.self, from: data).products
    }
    
    func fetchProductById(id: Int) async throws -> Product {
        guard let url = URL(string: "\(baseURL)/products/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Product.self, from: data)

    }

}
