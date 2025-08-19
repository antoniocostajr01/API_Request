//
//  Cart.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//
import SwiftUI

struct Cart: View {
    @EnvironmentObject var cart: CartStore

    var body: some View {
        VStack(spacing: 12) {
            if cart.items.isEmpty {
                ContentUnavailableView("Your cart is empty", systemImage: "cart")
                    .padding(.top, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(cart.items.values.sorted(by: { $0.id < $1.id })) { item in
                            ProductListCounter(product: item.product)
                                .environmentObject(cart)
                                .frame(maxWidth: .infinity)
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
                    Text("R$ \(cart.subtotal, specifier: "%.2f")")
                        .font(.headline)
                }
                Button {
                     //ir para orders
                     //arrumar fonte do botao - do details tb
                     //arrumar empty state
                     //limitar para 9
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
        .navigationTitle("Cart")
    }
}

