//
//  ProductVertical.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
//
import SwiftUI

struct ProductCardVertical: View {
    let title: String
    let price: String
    @State private var isFavorite = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 177, height: 250)
            .overlay(
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .frame(height: 160)
                        .overlay(alignment: .topTrailing) {
                            FavoriteIcon(isFavorite: isFavorite)
                        }
                        .overlay {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color(.fillsTertiary))
                        }
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)

                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(8)
            )
    }
}

#Preview {
    ProductCardVertical(
        title: "Product name with two or more lines goes here",
        price: "US$ 00,00"
    )
}

