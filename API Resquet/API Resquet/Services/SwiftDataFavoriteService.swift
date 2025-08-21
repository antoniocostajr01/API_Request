//
//  SwiftDataService.swift
//  API Resquet
//
//  Created by Antonio Costa on 20/08/25.
//

import Foundation
import SwiftData

class SwiftDataFavoriteService{
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataFavoriteService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: FavoriteProduct.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
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
