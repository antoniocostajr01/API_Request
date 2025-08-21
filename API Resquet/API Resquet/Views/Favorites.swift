//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Favorites: View {
    
    @StateObject var favoriteProductViewModel: FavoriteViewModel = FavoriteViewModel(
        dataSource: .shared,
        service: DummyJSONService()
    )
    
    var body: some View {
        Group {
            if favoriteProductViewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Carregando favoritos...")
                    Spacer()
                }
            } else if favoriteProductViewModel.products.isEmpty {
                VStack {
                    Spacer()
                    Text("Você ainda não tem favoritos 😢")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollView {
                    ForEach(favoriteProductViewModel.products) { product in
                        ProductListCart(
                            title: product.title,
                            price: String(product.price),
                            imageURL: product.thumbnail,
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
    }
}


