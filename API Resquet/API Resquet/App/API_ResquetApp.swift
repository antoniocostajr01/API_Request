//
//  API_ResquetApp.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI
import SwiftData

@main
struct API_ResquetApp: App {

    @StateObject private var cart = CartViewModel (dataSource: CartSwiftDataSerive.shared, service: DummyJSONService())
    @StateObject private var order = OrdersItem()
    @StateObject var favoriteVM = FavoriteViewModel(dataSource: .shared, service: DummyJSONService())

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(cart)
                .environmentObject(order)
                .environmentObject(favoriteVM)
        }
        
    }
}
