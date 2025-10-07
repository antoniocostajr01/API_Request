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
    @Published var isFavorite: Bool = false

    @Published var searchText = "" {
        didSet{
            filterProducts()
        }
    }
    
    private let service: APIServicing
    private let swiftDataFavoriteService: SwiftDataService

    
    init(service: APIServicing) {
        self.service = service
        self.swiftDataFavoriteService = SwiftDataService.shared

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
    
    func toggleIsFavorite(id: Int) {
        var favorites: [FavoriteProduct] = swiftDataFavoriteService.fetchFavoriteProducts()
        
        favorites = favorites.filter{ $0.id == id }
        
        if favorites.isEmpty {
            let favoriteProduct = FavoriteProduct(id: id)
            swiftDataFavoriteService.addFavoriteProduct(favoriteProduct)
        } else {
            swiftDataFavoriteService.deleteFavoriteProduct(id: id)
        }
        
        isFavorite.toggle()
    }
    
    func getFavorites() -> [FavoriteProduct] {
        swiftDataFavoriteService.fetchFavoriteProducts()
    }
}
