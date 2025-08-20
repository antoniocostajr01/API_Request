//
//  EmptyStateOrders.swift
//  API Resquet
//
//  Created by sofia leitao on 20/08/25.
//

import SwiftUI

struct EmptyStateOrders: View {
    var body: some View {
        VStack {
            VStack{
                Image(systemName: "bag.badge.questionmark")
                    .resizable()
                    .frame(width: 65, height: 60)
                    .foregroundStyle(.graysGray2)
                    .padding(8)
                Text("No orders yet!")
                    .foregroundStyle(.labelsPrimary)
                    .font(.system(.body, weight: .semibold))
            }
            
            Text("Buy an item and it will show up here.")
                .foregroundStyle(.labelsSecondary)
                .font(.system(.body, weight: .regular))
                .padding()
        }
        .padding()
    }
}

#Preview {
    EmptyStateOrders()
}
