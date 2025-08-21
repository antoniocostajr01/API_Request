import SwiftUI

struct ProductVertical: View {
    let title: String
    let price: String
    var imageURL: String? = nil
    var onTap: (() -> Void)? = nil
    @State private var isFavorite = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .accessibilityHidden(true)
            .frame(width: 177, height: 250)
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.fillsTertiary))
                            .accessibilityHidden(true)

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

                        FavoriteIcon(isFavorite: isFavorite) {
                            isFavorite.toggle()
                        }
                        .padding(6)
                        .accessibilityElement()
                        .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
                        .accessibilityValue(Text(isFavorite ? "Favorite" : "Not favorite"))
                        .accessibilityHint(Text(isFavorite ? "Double tap to remove from favorites" : "Double tap to add to favorites"))
                        .accessibilityAddTraits(.isButton)
                        .accessibilitySortPriority(1)
                    }
                    .frame(height: 160)

                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)
                        .lineLimit(2, reservesSpace: true)

                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(8)
                .contentShape(Rectangle())
                .onTapGesture { onTap?() }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    Text("\(title), price \(price)")
                )
                .accessibilityHint(Text("Double tap to see more details"))
                .accessibilityAddTraits(.isButton)
                .accessibilitySortPriority(2)
            )
    }
}

