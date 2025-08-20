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

                    // Image container
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
                                case .empty:
                                    // placeholder while loading
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.labelsPrimary)
                                case .failure(_):
                                    // fallback on failure
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.labelsPrimary)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .allowsHitTesting(false) // don’t block taps
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.labelsPrimary)
                        }
                    }
                    .frame(width: 74, height: 74)
                    .clipped()

                    // Right-side texts (optional)
                    VStack(alignment: .leading, spacing: 6) {
                        if let deliverText {
                            Text(deliverText.uppercased())
                                .font(.caption)
                                .foregroundStyle(.labelsSecondary)
                        }

                        Text(product.title)
                            .font(.footnote)
                            .foregroundStyle(.labelsPrimary)
                            .lineLimit(2)

                        if let priceText {
                            Text(priceText)
                                .font(.headline)
                                .foregroundStyle(.labelsPrimary)
                        }
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
            )
    }
}
