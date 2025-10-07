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
    var closure: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button {
                if value > range.lowerBound { value -= 1 }
                closure()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.fillsTertiary))
                    .frame(width: 30, height: 30)
                    .overlay(Text("–"))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Diminuir quantidade")

            Text("\(value)")
                .font(.title3)
                .foregroundStyle(.labelsPrimary)
                .frame(minWidth: 14)
                .accessibilityLabel("Quantidade atual")
                .accessibilityValue("\(value)")

            Button {
                if value < range.upperBound { value += 1 }
                closure()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.fillsTertiary))
                    .frame(width: 30, height: 30)
                    .overlay(Text("+"))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Aumentar quantidade")
        }
    }
}


struct ProductListCounter: View {
    @EnvironmentObject var cart: CartViewModel
    let product: Product
    var closure: () -> Void

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
                            Group {
                                if let thumb = product.thumbnail,
                                   let url = URL(string: thumb) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let img):
                                            img.resizable().scaledToFill()
                                                .accessibilityLabel("Imagem de \(product.title)")
                                        default:
                                            Image(systemName: "bag.fill")
                                                .font(.system(size: 35))
                                                .foregroundStyle(.labelsPrimary)
                                                .accessibilityLabel("Imagem indisponível")
                                        }
                                    }
                                } else {
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 35))
                                        .foregroundStyle(.labelsPrimary)
                                        .accessibilityLabel("Imagem indisponível")
                                }
                            }
                            .frame(width: 74, height: 74)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.footnote)
                            .foregroundStyle(.labelsPrimary)

                        Text(String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", product.price))
                            .font(.headline)
                            .foregroundStyle(.labelsPrimary)
                    }
                    .accessibilityElement(children: .combine) //titulo e preco juntos

                    Spacer(minLength: 0)

                    QuantityStepper(value: cart.binding(for: product), closure: closure)
                        .accessibilityLabel("Quantidade de \(product.title)")
                }
                .padding(16)
            )
    }
}
