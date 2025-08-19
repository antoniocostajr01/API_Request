//
//  EmptyStateCart.swift
//  API Resquet
//
//  Created by sofia leitao on 19/08/25.
//

import SwiftUI

struct EmptyStateCart: View {
    var body: some View {
        Text(Image(systemName:"cart.badge.questionmark"))
    }
}

#Preview {
    EmptyStateCart()
}
