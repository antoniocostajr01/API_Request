import SwiftUI

struct ProductVertical: View {
    let title: String
    let price: String
    var imageURL: String? = nil
    var isFavorite = false
    var onTap: () -> Void = {}
    var onFavoriteTap: () -> Void = {}

    /// 👉 New: external size controller
    let frame: CGRect

    // Tunables
    private let cardRadius: CGFloat = 16
    private let imageRadius: CGFloat = 8
    private let paddingAll: CGFloat = 8

    // Image area ~64% of card height (adjust if you like)
    private var imageHeight: CGFloat { frame.height * 0.64 }

    var body: some View {
        RoundedRectangle(cornerRadius: cardRadius)
            .fill(Color(.backgroundsSecondary))
            .accessibilityHidden(true)
            .frame(width: frame.width, height: frame.height)
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: imageRadius)
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
                            .clipShape(RoundedRectangle(cornerRadius: imageRadius))
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

                            onFavoriteTap() //Só cuida de favoritar o produto

                        }
                        .padding(6)
                        .accessibilityElement()
                        .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
                        .accessibilityValue(Text(isFavorite ? "Favorite" : "Not favorite"))
                        .accessibilityHint(Text(isFavorite ? "Double tap to remove from favorites" : "Double tap to add to favorites"))
                        .accessibilityAddTraits(.isButton)
                        .accessibilitySortPriority(1)
                    }
                    .frame(height: imageHeight)

                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)
                        .lineLimit(2, reservesSpace: true)

                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(paddingAll)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap() // Só cuida de mostrar os detalhes do produto
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text("\(title), price \(price)"))
                .accessibilityHint(Text("Double tap to see more details"))
                .accessibilityAddTraits(.isButton)
                .accessibilitySortPriority(2)
            )
            .contentShape(Rectangle())
    }
}

