//
//  FavoriteIcon.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
import SwiftUI

struct FavoriteIcon: View {
    @State var isFavorite: Bool
    
    var body: some View {
        Button (action: {
            isFavorite.toggle()
        }) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.fillsTertiary)
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.labelsPrimary)
                )
        }
    }
}

#Preview {
    FavoriteIcon(isFavorite: false)
}
