//
//  SwiftDataService.swift
//  API Resquet
//
//  Created by Antonio Costa on 20/08/25.
//

import Foundation
import SwiftData

class SwiftDataService{
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: FavoriteProduct.self, CartPersistence.self, Order.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext


    }
    
    func fetchCart() -> [CartPersistence] {
            do {
                return try modelContext.fetch(FetchDescriptor<CartPersistence>())
            } catch {
                print(error.localizedDescription)
                return []
            }
        }
        
        func addProductToCart(product: CartPersistence) {
            modelContext.insert(product)
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func deleteProductFromCart(product: CartPersistence) {
            modelContext.delete(product)
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func updateCartQuantity(product: CartPersistence, newQuantity: Int) {
            product.quantity = newQuantity
            try? modelContext.save()
        }
    
    
    
    
    func fetchFavoriteProducts() -> [FavoriteProduct] {
        do {
            return try modelContext.fetch(FetchDescriptor<FavoriteProduct>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addFavoriteProduct(_ product: FavoriteProduct) {
        modelContext.insert(product)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteFavoriteProduct(id: Int) {
        let fetchDescriptor = FetchDescriptor<FavoriteProduct> (
            predicate: #Predicate { $0.id == id }
        )
        do{
            if let productToDelete = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(productToDelete)
                try modelContext.save()
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
