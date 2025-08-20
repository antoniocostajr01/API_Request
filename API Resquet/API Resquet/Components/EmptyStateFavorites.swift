//
//  EmptyStateOrders.swift
//  API Resquet
//
//  Created by sofia leitao on 20/08/25.
//

import SwiftUI

struct EmptyStateFavorites: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "heart.slash")
                    .resizable()
                    .frame(width: 65, height: 60)
                    .foregroundStyle(.graysGray2)
                    .padding(8)
                Text("No favorites yet!")
                    .foregroundStyle(.labelsPrimary)
                    .font(.system(.body, weight: .semibold))
            }
            
            Text("Favorite an item and it will show up here.")
                .foregroundStyle(.labelsSecondary)
                .font(.system(.body, weight: .regular))
                .padding()
        }
        .padding()
    }
}

#Preview {
    EmptyStateFavorites()
}
