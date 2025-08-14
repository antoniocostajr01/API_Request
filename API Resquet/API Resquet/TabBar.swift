//
//  TabBar.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView{
            
            Tab("Home", systemImage: "house.fill"){
                NavigationStack {
                    Home()
                }
            }
            
            Tab("Categories", systemImage: "square.grid.2x2.fill"){
                NavigationStack {
                    Categories()
                }
            }
            
            Tab("Cart", systemImage: "cart.fill"){
                NavigationStack {
                    Cart()
                }
            }
            
            Tab("Favorites", systemImage: "heart.fill"){
                NavigationStack {
                    Favorites()
                }
            }
            
            Tab("Orders", systemImage: "bag.fill"){
                NavigationStack {
                    Orders()
                }
            }
            
            
            
        }
    }
}

#Preview {
    TabBar()
}
