import SwiftUI

struct ProductVertical: View {
    let title: String
    let price: String
    var imageURL: String? = nil
    var isFavorite = false
    var onTap: () -> Void = {}

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 177, height: 250)
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.fillsTertiary))

                        if let imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img): img.resizable().scaledToFill()
                                default:
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 44))
                                        .foregroundStyle(Color(.systemGray3))
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .allowsHitTesting(false)
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color(.systemGray3))
                        }

                        FavoriteIcon(isFavorite: isFavorite) {
                            onTap()   // later: persist with SwiftData
                        }
                        .padding(6)
                    }
                    .frame(height: 160)

                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)
                        .lineLimit(2)

                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(8)
            )
            .contentShape(Rectangle())
    }
}

