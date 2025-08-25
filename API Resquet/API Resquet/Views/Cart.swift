//
//  Cart.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//
import SwiftUI

struct Cart: View {
    
    @StateObject private var cart = CartViewModel (dataSource: SwiftDataService.shared, service: DummyJSONService())
    @EnvironmentObject var orders: OrderViewModel
    @State private var goToOrders = false
        

    var body: some View {
        VStack(spacing: 12) {
            if cart.items.isEmpty {
                EmptyStateCart()
            } else {
                let sortedItems = cart.items.values.sorted { $0.id < $1.id }
                let limitedItems = Array(sortedItems.prefix(9))
                let limitedSubtotal = limitedItems.reduce(0.0) { acc, item in
                    acc + (item.product.price * Double(item.quantity))
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(limitedItems) { item in
                            ProductListCounter(product: item.product)
                                .environmentObject(cart)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                VStack {
                    HStack {
                        Text("Total: ")
                            .foregroundStyle(.labelsPrimary)
                            .font(.subheadline)
                        Spacer()
                        Text(String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", limitedSubtotal))
//                        Text("R$ \(limitedSubtotal, specifier: "%.2f")")
                            .font(.headline)
                    }

                    Button {
                        orders.save(items: limitedItems)
                        goToOrders = true
                        cart.clear()
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.fillsTertiary))
                            .frame(height: 54)
                            .overlay(Text("Checkout"))
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 16)
            }
        }
        .task {
            await cart.loadPersistence()
        }
        .navigationTitle("Cart")
    }
}


