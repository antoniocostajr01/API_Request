//
//  viewmodels.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var deals: [Product] = []
    @Published var topPicks: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: ProductServicing

    init(service: ProductServicing = ProductService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {

            let res = try await service.fetchProducts(limit: 0, skip: 0)
            let all = res.products
            
            deals = Array(
                all.sorted { ($0.discountPercentage ?? 0) > ($1.discountPercentage ?? 0) }
                   .prefix(10)
            )
    
            topPicks = all
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
