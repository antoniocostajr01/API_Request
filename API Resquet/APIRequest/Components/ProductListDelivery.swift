//
//  ProductListDelivery.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
import SwiftUI

struct ProductListDelivery: View {
    let product: Product
    var deliverText: String? = nil
    var priceText: String? = nil

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 361, height: 94)
            .overlay(
                HStack(spacing: 16) {

                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.fillsTertiary))

                        if let thumb = product.thumbnail,
                           let url = URL(string: thumb) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img):
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .accessibilityLabel("Imagem de \(product.title)")
                                case .empty:
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.labelsPrimary)
                                        .accessibilityLabel("Imagem indisponível")
                                case .failure(_):
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.labelsPrimary)
                                        .accessibilityLabel("Imagem indisponível")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .allowsHitTesting(false)
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.labelsPrimary)
                                .accessibilityLabel("Imagem indisponível")
                        }
                    }
                    .frame(width: 74, height: 74)
                    .clipped()

                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        [
                            deliverText?.uppercased(),
                            product.title
                        ]
                            .compactMap { $0 }
                            .joined(separator: ", ")
                    )
                    .accessibilityValue(priceText ?? "")

                    Spacer(minLength: 0)
                }
                .padding(16)
            )
    }
}
