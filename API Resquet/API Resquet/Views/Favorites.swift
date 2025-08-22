//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Favorites: View {
    
    @EnvironmentObject var cart: CartStore
    
    @StateObject var favoriteProductViewModel: FavoriteViewModel = FavoriteViewModel(
        dataSource: .shared,
        service: DummyJSONService()
    )
    
    var body: some View {
        VStack {
            if favoriteProductViewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Carregando favoritos...")
                    Spacer()
                }
            } else if favoriteProductViewModel.products.isEmpty {
                
                EmptyStateFavorites()
                
            } else {
                ScrollView {
                    ForEach(favoriteProductViewModel.products, id: \.id) { product in
                        ProductListCart(
                            title: product.title,
                            price: String(product.price),
                            imageURL: product.thumbnail ?? "",
                            product:product,
                            inCart: false
                        )
                    }
                }
            }
        }
        .task {
                await favoriteProductViewModel.fetchFavorites()
        }
        .padding()
        .navigationTitle("Favorites")
//        .environmentObject(favoriteProductViewModel)
//        .environmentObject(cart)
    }
}


