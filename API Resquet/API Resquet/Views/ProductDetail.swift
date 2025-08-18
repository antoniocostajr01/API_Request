//
//  ProductDetailView.swift
//  API Resquet
//
//  Created by sofia leitao on 15/08/25.
//
import SwiftUI

struct ProductDetail: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let thumb = product.thumbnail, let url = URL(string: thumb) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable().scaledToFill()
                            default:
                                Color(.systemGray5)
                            }
                        }
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Text(product.title)
                        .font(.title2).bold()
                        .padding()

                    Text("US$ " + String(format: "%.2f", product.price))
                        .font(.title3).bold()
                        .padding()

                    if let desc = product.description, !desc.isEmpty {
                        Text(desc)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .padding()
                    }
                    
                    Button {
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.fillsTertiary)
                            .frame(width: 361, height: 54)
                            .overlay(
                                Text("Add to cart")
                            )
                    }
                    .buttonStyle(.plain)
                    .padding()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Details")
        }
    }
}

