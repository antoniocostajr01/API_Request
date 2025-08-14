//
//  ProductHorizontal.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
//

import SwiftUI

struct ProductHorizontal: View {
    let category: String
    let title: String
    let price: String
    @State private var isFavorite = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 361, height: 176)
            .overlay(
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .frame(width: 160, height: 160)
                        .overlay {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color(.systemGray3))
                        }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.uppercased())
                            .font(.caption)
                            .foregroundColor(.labelsSecondary)
                        
                        Text(title)
                            .font(.body)
                            .foregroundColor(.labelsPrimary)
                        
                        Text(price)
                            .font(.headline).bold()
                            .foregroundColor(.labelsPrimary)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(16)
            )
            .overlay(alignment: .topTrailing) {
                FavoriteIcon(isFavorite: isFavorite) 
                    .padding(8)
            }
    }
}


#Preview {
    ProductHorizontal(
        category: "CATEGORY",
        title: "Product name with two or more lines goes here",
        price: "US$ 00,00"
    )
}
