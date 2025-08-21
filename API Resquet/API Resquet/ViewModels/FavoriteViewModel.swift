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
        
    private let dataSource: SwiftDataFavoriteService
    private let service: APIServicing
    
    init(dataSource: SwiftDataFavoriteService, servive: APIServicing ) {
        self.dataSource = dataSource
        self.service = servive
        
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
        for favorite in dataSource.fetchFavoriteProducts() {
            await getProductFromAPI(id: favorite.id)
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains { $0.id == id }
    }
    
//    func toggleFavorite(id: Int) {
//        if isFavorite(id: id) {
//            removeFavorite(id: id)
//        }
//    }
//    
//    func addFavorite(id: Int) {
//        let favoriteProduct = FavoriteProduct(id: id)
//        
//        dataSource.addFavoriteProduct(favoriteProduct)
//        fetchFavorites()
//    }
//    
//    
//    private func removeFavorite(id: Int) {
//        dataSource.deleteFavoriteProduct(id: id)
//        fetchFavorites()
//    }
    
}
