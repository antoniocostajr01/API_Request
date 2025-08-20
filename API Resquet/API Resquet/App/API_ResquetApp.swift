//
//  API_ResquetApp.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

@main
struct API_ResquetApp: App {
    @StateObject private var cart = CartStore()
    @StateObject private var order = OrdersItem()
    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(cart)
                .environmentObject(order)
        }
        
    }
}
