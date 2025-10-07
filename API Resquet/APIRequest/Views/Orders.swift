
//
//  Favorites.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Orders: View {
    @EnvironmentObject var orders: OrderViewModel

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
        .navigationTitle(String(localized: "Orders", defaultValue: "Orders"))
        .searchable(
            text: $orders.query,
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

