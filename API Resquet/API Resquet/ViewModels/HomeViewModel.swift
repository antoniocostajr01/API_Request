//
//  viewmodels.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedProduct: Product? = nil
//    @Binding var isFavorite: Bool
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private let service: APIServicing

    init(service: APIServicing) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await service.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
