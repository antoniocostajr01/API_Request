//
//  OrderViewModelSwiftTests.swift
//  API Resquet
//
//  Created by Antonio Costa on 25/08/25.
//

import Foundation
@testable import APIRequest

class APIServiceMock: APIServicing {
    
    var products: [APIRequest.Product] = []
    var shouldFail: Bool
    var categories: [APIRequest.Category] = []
    
    init(products: [APIRequest.Product] = [Product(id: 1, title: "title", description: "description", category: "beauty", price: 12.4, brand: "brand", thumbnail: "image")], shouldFail: Bool = false,
         categories: [APIRequest.Category] = [Category(slug: "beauty", name: "beauty", url: "beauty")]
    ) {
        self.products = products
        self.shouldFail = shouldFail
        self.categories = categories
    }
    
    
    func fetchProducts() async throws -> [APIRequest.Product] {
        if shouldFail {
            throw NSError(domain: "", code: 0, userInfo: nil)
        } else {
            return products
        }
    }
    
    func fetchCategories() async throws -> [APIRequest.Category] {
        if shouldFail {
            throw NSError(domain: "", code: 0, userInfo: nil)
        } else {
            return categories
        }
    }
    
    func fetchProductsByCategory(forCategory categoryName: String) async throws -> [APIRequest.Product] {
        if shouldFail {
            throw NSError(domain: "", code: 0, userInfo: nil)
        } else {
            var productsByCategory: [APIRequest.Product] = []
            for product in products {
                product.category == categoryName ? productsByCategory.append(product) : ()
            }
            return productsByCategory
        }
    }
    
    func fetchProductById(id: Int) async throws -> APIRequest.Product {
        if let match = products.first(where: { $0.id == id }) {
            return match
        }
        throw NSError(domain: "APIServiceMock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
    }
    
    
    
}
