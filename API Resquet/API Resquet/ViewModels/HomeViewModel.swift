//
//  viewmodels.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedProduct: Product? = nil
    @Published var isFavorite: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private let service: APIServicing
    private let swiftDataFavoriteService: SwiftDataService

    init(service: APIServicing) {
        self.service = service
        self.swiftDataFavoriteService = SwiftDataService.shared
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await service.fetchProducts()
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
