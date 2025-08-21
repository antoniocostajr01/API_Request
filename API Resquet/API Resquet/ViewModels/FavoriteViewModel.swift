//
//  FavoriteViewModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 19/08/25.
//

import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favorites: [FavoriteProduct] = []
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
        
    private let dataSource: SwiftDataFavoriteService
    private let service: APIServicing
    
    init(dataSource: SwiftDataFavoriteService, service: APIServicing ) {
        self.dataSource = dataSource
        self.service = service
        
        // 1 - CRIAR FUNCAO QUE PEGA TODOS OS FAVORITOS
        // 2 - TIPO UM MAP PARA TER TODOS OS IDS EXISTENTES
        // 3 - PARA CADA ID, FAZER UM FETCH DA API BUSCANDO POR AQUELE PRODUTO PELO ID
        // 4 - ARMAZENAR ISSO EM UMA PUBLISHED
        // 5 - CONSUMIR A LISTA DE PRODUT
       
    }
    
    func getProductFromAPI(id: Int) async {
        do {
            let product = try await service.fetchProductById(id: id)
            products.append(product)
        } catch{
            print("\(error.localizedDescription)")
        }
    }
    
    func fetchFavorites() async {
        isLoading = true
        products.removeAll()

        let favorites = dataSource.fetchFavoriteProducts()

        await withTaskGroup(of: Product?.self) { group in
            for favorite in favorites {
                group.addTask {
                    do {
                        return try await self.service.fetchProductById(id: favorite.id)
                    } catch {
                        print("Erro ao buscar produto \(favorite.id): \(error)")
                        return nil
                    }
                }
            }

            for await product in group {
                if let product = product {
                    await MainActor.run {
                        self.products.append(product)
                    }
                }
            }
        }

        isLoading = false
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains { $0.id == id }
    }
    
    func toggleFavorite(id: Int) {
        if isFavorite(id: id) {
            removeFavorite(id: id)
        }
    }
    
    func addFavorite(id: Int) async {
        let favoriteProduct = FavoriteProduct(id: id)
        dataSource.addFavoriteProduct(favoriteProduct)
        await fetchFavorites() // precisa do await
    }

    private func removeFavorite(id: Int) {
        dataSource.deleteFavoriteProduct(id: id)
        Task { await fetchFavorites() } // precisa rodar em Task
    }
    
}
