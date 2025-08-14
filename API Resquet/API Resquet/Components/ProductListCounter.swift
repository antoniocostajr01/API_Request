//
//  ProductListCounter.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
//
import SwiftUI

struct QuantityStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...99
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                if value > range.lowerBound { value -= 1 }
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.fillsTertiary))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("–")
                    )
            }
            .buttonStyle(.plain)
            
            Text("\(value)")
                .font(.title3)
                .foregroundStyle(.labelsPrimary)
                .frame(minWidth: 14)
            Button {
                if value < range.upperBound { value += 1 }
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.fillsTertiary))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("+")
                    )
            }
            .buttonStyle(.plain)
        }
    }
}


struct ProductListCounter: View {
    let category: String
    let title: String
    let price: String
    
    @State private var quantity = 0
    
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
 
                    QuantityStepper(value: $quantity)
                }
                .padding(16)
            )
    }
}

#Preview {
    ProductListCounter(
        category: "CATEGORY",
        title: "Product name with two or more lines goes here",
        price: "US$ 00,00"
    )
}

