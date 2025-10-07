
//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Orders: View {
    @EnvironmentObject var orders: OrderViewModel

    @State private var query: String = ""

//    private var filteredItems: [CartPersistence] {
//        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            return orders.items
//        }
//        return orders.items.filter { item in
//            item.product.title.range(
//                of: query,
//                options: [.caseInsensitive, .diacriticInsensitive]
//            ) != nil
//        }
//    }

    var body: some View {
        VStack(spacing: 12) {
            if orders.items.isEmpty {
             EmptyStateOrders()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(orders.items) { item in
                            ProductListDelivery(
                                product: orders.getElementById(id: item.id),
                                deliverText: orders.eta(orderDate: item.date),
                                priceText:
                                    String(
                                        format: "\(String(localized: "Currency", defaultValue: "US$")) %.2f", item.amount
                                )
                        )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle("Orders")
        .searchable(
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search products"
        )
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .task {
            await orders.loadPersistence()
        }
    }
}

