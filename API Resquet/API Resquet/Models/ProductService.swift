//
//  servies.swift
//  API Resquet
//
//  Created by sofia leitao on 15/08/25.
//
import Foundation

protocol ProductServicing {
    func fetchProducts(limit: Int?, skip: Int?) async throws -> ProductsResponse
}

struct ProductService: ProductServicing {
    func fetchProducts(limit: Int? = nil, skip: Int? = nil) async throws -> ProductsResponse {
        var comps = URLComponents(string: "https://dummyjson.com/products")!
        var items: [URLQueryItem] = []
        if let limit { items.append(.init(name: "limit", value: String(limit))) }
        if let skip { items.append(.init(name: "skip", value: String(skip))) }
        comps.queryItems = items.isEmpty ? nil : items

        let (data, resp) = try await URLSession.shared.data(from: comps.url!)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(ProductsResponse.self, from: data)
    }
}
