//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Favorites: View {
    
    @StateObject var favoriteProductViewModel: FavoriteViewModel = FavoriteViewModel(dataSource: .shared, servive: DummyJSONService())
    
    
    
    var body: some View {
        
        ScrollView{
            ForEach(favoriteProductViewModel.products){ product in
                ProductListCart(title: product.title, price: String(product.price), imageURL: product.thumbnail, inCart: false)
            }
        }
        .task {
            await favoriteProductViewModel.fetchFavorites()
        }
        .padding()
        .navigationTitle("Favorites")

    }
}



