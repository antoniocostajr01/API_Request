import SwiftUI

struct ProductHorizontal: View {
    let category: String
    let title: String
    let price: String
    var imageURL: String? = nil
    let onTap: () -> Void
    @State private var isFavorite = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.backgroundsSecondary))
            .frame(width: 361, height: 176)
            .overlay(
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.fillsTertiary))
                        .frame(width: 160, height: 160)
                        .overlay {
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
                        Text(category.uppercased())
                            .font(.caption)
                            .foregroundColor(.labelsSecondary)

                        Text(title)
                            .font(.body)
                            .foregroundColor(.labelsPrimary)
                            .lineLimit(2)

                        Text("US$\(price)")
                            .font(.headline).bold()
                            .foregroundColor(.labelsPrimary)
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
            )
 
            .overlay(alignment: .topTrailing) {
                FavoriteIcon(isFavorite: isFavorite) {
                    isFavorite.toggle()      
                }
                .padding(8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
    }
}

