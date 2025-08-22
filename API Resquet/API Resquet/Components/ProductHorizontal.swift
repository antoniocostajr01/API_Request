//
//  FavoriteIcon.swift
//  API Resquet
//
//  Created by sofia leitao on 13/08/25.
//
import SwiftUI

struct ProductHorizontal: View {
    
    @EnvironmentObject var viewModelFavorites: FavoriteViewModel
    
    let category: String
    let title: String
    let price: String
    var imageURL: String? = nil
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    let onTap: () -> Void
  
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .accessibilityHidden(true)
            .frame(width: 361, height: 176)
            .overlay(
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .accessibilityHidden(true)
                        .frame(width: 160, height: 160)
                        .overlay {
                            if let imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img):
                                        img.resizable().scaledToFill()
                                    default:
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 44))
                                            .foregroundStyle(Color(.systemGray3))
                                    }
                                }
                                .frame(width: 160, height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .allowsHitTesting(false)
                                .accessibilityElement()
                                .accessibilityLabel(Text("Product image: \(title)"))
                                .accessibilityAddTraits(.isImage)
                            } else {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemGray3))
                                    .accessibilityLabel(Text("Placeholder product image"))
                                    .accessibilityAddTraits(.isImage)
                            }
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.uppercased())
                            .font(.caption)
                            .foregroundColor(.labelsSecondary)
                            .accessibilityHidden(true)

                        Text(title)
                            .font(.body)
                            .foregroundColor(.labelsPrimary)
                            .lineLimit(2)
                        Text("US$ \(price)")
                            .font(.headline).bold()
                            .foregroundColor(.labelsPrimary)
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
                .contentShape(Rectangle())
                .onTapGesture { onTap() }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    Text("\(title), price US$\(price)")
                )
                .accessibilityHint(Text("Click to see more details"))
                .accessibilityAddTraits(.isButton)
                .accessibilityAction(.magicTap, onTap) //dois toques entra no details
                .accessibilitySortPriority(2) //card antes do botao de favorito
            )
            .overlay(alignment: .topTrailing) {
                FavoriteIcon(isFavorite: isFavorite) {
                    
                    onFavoriteTap()
                    
                }
                .padding(8)
                .accessibilityElement()
                .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
                .accessibilityValue(Text(isFavorite ? "Favorite" : "Not favorite"))
                .accessibilityHint(Text(isFavorite ? "Double tap to remove from favorites" : "Double tap to add to favorites"))
                .accessibilityAddTraits(.isButton)
                .accessibilitySortPriority(1)
                
            }
    }
}
