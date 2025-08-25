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
    
    @StateObject private var order = OrdersItem()
    @StateObject private var cart = CartViewModel(
        dataSource: .shared,
        service: DummyJSONService()
    )


    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(order)
                .environmentObject(cart)
        }
        
    }
}
