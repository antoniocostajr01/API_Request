
import SwiftUI

struct ProductVertical: View {
    let title: String
    let price: String
    var imageURL: String? = nil           
    @State private var isFavorite = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 177, height: 250)
            .overlay(
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .frame(height: 160)
                        .overlay(alignment: .topTrailing) {
                            FavoriteIcon(isFavorite: isFavorite)
                        }
                        .overlay {
                            if let imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img):
                                        img.resizable().scaledToFill()
                                    case .empty, .failure(_):
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 44))
                                            .foregroundStyle(Color(.systemGray3))
                                    @unknown default:
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 44))
                                            .foregroundStyle(Color(.systemGray3))
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemGray3))
                            }
                        }

                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)
                        .lineLimit(2)

                    Text(price) // already includes "US$"
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(8)
            )
    }
}

