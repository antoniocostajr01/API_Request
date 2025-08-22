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
                
                EmptyStateFavorites()
                
            } else {
                ScrollView {
                    ForEach(favoriteProductViewModel.products) { product in
                        Group {
                            let currency = String(localized: "Currency", defaultValue: "US$")
                            let amount   = String(format: "%.2f", product.price)
                            ProductListCart(
                                title: product.title,
                                price: "\(currency) \(amount)",
                                imageURL: product.thumbnail,
                                inCart: false
                            )
                        }
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


