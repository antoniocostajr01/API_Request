//
//  ProductListCart.swift
//  API Resquet
//
//  Created by sofia leitao on 14/08/25.
//
import SwiftUI

struct ProductListCart: View {
    let title: String
    let price: String
    let imageURL: String? 
    
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
                            if let imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img): img.resizable().scaledToFill().frame(width: 74, height: 74)

                                    default:
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 44))
                                            .foregroundStyle(Color(.systemGray3))
                                    }
                                }
                                .frame(width: 160, height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .allowsHitTesting(false)
                            } else {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemGray3))
                            }
                            
                        }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.footnote)
                            .foregroundStyle(.labelsPrimary)
                        
                        Text(price)
                            .font(.headline)
                            .foregroundStyle(.labelsPrimary)
                    }
                    
                    Spacer()
                    
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
                            .padding(.trailing, 8)
                    }
                    
                }
                    .padding(8)
            )
        
    }
    
}

//#Preview {
//    ProductListCart(
//        title: "Product name with two or more lines goes here",
//        price: "US$ 00,00",
//        inCart: false
//    )
//}
