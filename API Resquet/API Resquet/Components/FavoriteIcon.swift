//
//  FavoriteIcon.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import SwiftUI

struct FavoriteIcon: View {
    var isFavorite: Bool
    var cornerRadius: CGFloat = 8
    var height: CGFloat = 38
    var width: CGFloat = 38
    var size: CGFloat = 20
    var onTap: () -> Void = {} 
    
    var body: some View {
        Button {
            // TODO: COLOCAR ISFAVORITE DO SWIFTDATA
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .imageScale(.medium)
                .padding(8)
                .frame(width: width, height: height)
                .font(.system(size: size))
                .background(.fillsTertiary, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
    }
    
}

