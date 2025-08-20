//
//  FavoriteViewModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 19/08/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteProduct {
    var id: Int
    
    init(id: Int, product: Product) {
        self.id = id
    }
}
