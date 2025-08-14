//
//  ProductListCart.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
//
import SwiftUI

struct ProductListCart: View {
    let category: String
    let title: String
    let price: String
    
    @State var inCart: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 361, height: 94)
            .overlay(
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .frame(width: 74, height: 74)
                        .overlay {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 35))
                                .foregroundStyle(Color(.fillsTertiary))
                        }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.footnote)
                            .foregroundStyle(.labelsPrimary)
                
                        Text(price)
                            .font(.headline)
                            .foregroundStyle(.labelsPrimary)
                    }
                    
                    Button (action: {
                        inCart.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.fillsTertiary)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Image(systemName: inCart ? "cart.fill" : "cart")
                                    .foregroundColor(.labelsPrimary)
                            )
                    }
                    
                }
                    .padding(8)
            )
        
    }
    
}

#Preview {
    ProductListCart(
        category: "CATEGORY",
        title: "Product name with two or more lines goes here",
        price: "US$ 00,00",
        inCart: false
    )
}
