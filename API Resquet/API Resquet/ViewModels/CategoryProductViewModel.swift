//
//  CategoryProductViewModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 18/08/25.
//

import Foundation

@MainActor
final class CategoryProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var searchText = "" {
        didSet{
            filterProducts()
        }
    }
    
    private let service: APIServicing
    
    init(service: APIServicing) {
        self.service = service
    }
    
    func filterProducts(){
        guard !searchText.isEmpty else{
            filteredProducts = products
            return
        }
        
        filteredProducts = products.filter{product in
            product.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    func loadProducts(category: Category) async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await service.fetchProductsByCategory(forCategory: category.slug)
            filterProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
