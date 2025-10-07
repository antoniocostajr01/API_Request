//
//  Cart.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//
import SwiftUI

struct Cart: View {
    
    private var cart = CartViewModel (dataSource: SwiftDataService.shared, service: DummyJSONService())
    @EnvironmentObject var orders: OrderViewModel
        

    var body: some View {
        VStack(spacing: 12) {
            if cart.items.isEmpty {
                EmptyStateCart()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(cart.productsFiltered) { item in
                            ProductListCounter(product: item.product, closure: {
                                cart.setList()
                            })
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
                        Text(String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", cart.limitedSubtotal))
                            .font(.headline)
                    }

                    Button {
                        orders.save(items: cart.limitedItems)
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


