////
////  CartServiceSwiftData.swift
////  API Resquet
////
////  Created by Antonio Costa on 23/08/25.
////
//
//import Foundation
//import SwiftData
//
//class CartSwiftDataSerive {
//    
//    private let modelContainer: ModelContainer
//    private let modelContext: ModelContext
//    
//    @MainActor
//    static let shared = CartSwiftDataSerive()
//    
//    @MainActor
//    private init() {
//        self.modelContainer = try! ModelContainer(for: CartPersistence.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
//        self.modelContext = modelContainer.mainContext
//    }
//    
//    func fetchProducts() -> [CartPersistence] {
//        do {
//            return try modelContext.fetch(FetchDescriptor<CartPersistence>())
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
//    
//    func addProduct(item: CartPersistence) {
//        modelContext.insert(item)
//        do {
//            try modelContext.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func deleteProduct(id: Int) {
//        let fetchDescriptor = FetchDescriptor<CartPersistence> (
//            predicate: #Predicate { $0.id == id }
//        )
//        do {
//            if let productToDelete = try modelContext.fetch(fetchDescriptor).first { modelContext.delete(productToDelete)
//                try modelContext.save()
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//    func updateProduct(id: Int, quantity: Int) {
//        let fetchDescriptor = FetchDescriptor<CartPersistence>(
//            predicate: #Predicate { $0.id == id }
//        )
//        do {
//            if let productToUpdate = try modelContext.fetch(fetchDescriptor).first {
//                productToUpdate.quantity = quantity
//                try modelContext.save()
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
