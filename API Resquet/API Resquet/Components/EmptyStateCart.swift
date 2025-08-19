//
//  EmptyStateCart.swift
//  API Resquet
//
//  Created by sofia leitao on 19/08/25.
//

import SwiftUI

struct EmptyStateCart: View {
    var body: some View {
        
        VStack {
            VStack {
                Image(systemName: "cart.fill.badge.questionmark")
                    .resizable()
                    .frame(width: 65, height: 60)
                    .foregroundStyle(.graysGray2)
                    .padding(8)
                Text("Your cart is empty!")
                    .foregroundStyle(.labelsPrimary)
                    .font(.system(.body, weight: .semibold))
            }
            
            Text("Add an item to your cart.")
                .foregroundStyle(.labelsSecondary)
                .font(.system(.body, weight: .regular))
                .padding()
        }
        .padding()
    }
}

#Preview {
    EmptyStateCart()
}
