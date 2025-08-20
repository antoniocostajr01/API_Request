
//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Orders: View {
    @EnvironmentObject var orders: OrdersItem

    @State private var query: String = ""

    private var deliveryFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "MMMM, dd"
        return f
    }

    private var eta: String {
        let base = orders.createdAt ?? Date()
        let date = base.addingTimeInterval(60 * 60 * 24 * 7) // +7 days
        return "Delivery by \(deliveryFormatter.string(from: date)).".uppercased()
    }

    private var filteredItems: [CartItem] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return orders.items
        }
        return orders.items.filter { item in
            item.product.title.range(
                of: query,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            if filteredItems.isEmpty {
             EmptyStateOrders()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredItems) { item in
                            ProductListDelivery(
                                product: item.product,
                                deliverText: eta,
                                priceText: String(
                                    format: "US$ %.2f",
                                    item.product.price * Double(item.quantity)
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
    }
}

