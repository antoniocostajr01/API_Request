//
//  ProductListDelivery.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
import SwiftUI

struct ProductListDelivery: View {
    let title: String
    let price: String
    let deliver: String
    
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
                        Text(deliver.uppercased())
                            .font(.caption)
                            .foregroundColor(.labelsSecondary)
                        
                        Text(title)
                            .font(.footnote)
                            .foregroundStyle(.labelsPrimary)
                        
                        Text(price)
                            .font(.headline)
                            .foregroundStyle(.labelsPrimary)
                    }
                    
                }
                    .padding(16)
            )
    }
}

#Preview {
    ProductListDelivery(
        title: "Product name with two or more lines goes here",
        price: "US$ 00,00"  ,
        deliver: "DELIVERY BY MONTH, 00"
    )
}


