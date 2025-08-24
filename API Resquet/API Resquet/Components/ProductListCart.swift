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
    let product: Product
    
    @State var inCart: Bool
    
    @EnvironmentObject var cart: CartStore
    
    @StateObject var favorite: FavoriteViewModel = FavoriteViewModel(
        dataSource: .shared,
        service: DummyJSONService()
    )
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Imagem do produto
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.fillsTertiary))
                .frame(width: 74, height: 74)
                .overlay {
                    if let imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 74, height: 74)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            default:
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemGray3))
                            }
                        }
                    } else {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color(.systemGray3))
                    }
                }
            
            // Informações do produto
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(.labelsPrimary)
                
                Text(price)
                    .font(.headline)
                    .foregroundStyle(.labelsPrimary)
            }
            
            Spacer()
            
            // Botão de adicionar/remover do carrinho
            Button {
                inCart.toggle()
                cart.add(productId: product.id)
                favorite.removeFavorite(id: product.id)
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.fillsTertiary)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: inCart ? "cart.fill" : "cart")
                            .foregroundColor(.labelsPrimary)
                    )
            }
            .padding(.trailing, 8)
            
        }
        .padding(8)
        .frame(width: 361, height: 94)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.backgroundsSecondary))
        )
    }
}
