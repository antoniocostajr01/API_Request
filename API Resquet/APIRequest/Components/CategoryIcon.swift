//
//  CategoryIcon.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//

import SwiftUI

struct CategoryIcon: View {
    
    var icon: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.fillsTertiary)
            .frame(width: 84, height: 84)
            .overlay(
                Image(systemName: icon)
                    .foregroundColor(.fillsSecondary)
                    .font(.system(size: 38.88, weight: .regular))
            )
    }
}

