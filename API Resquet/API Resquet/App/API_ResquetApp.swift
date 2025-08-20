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
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(for: FavoriteProduct.self)
    }
}
