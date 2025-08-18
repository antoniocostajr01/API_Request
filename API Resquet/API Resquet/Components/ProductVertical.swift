
import SwiftUI

struct ProductVertical: View {
    let title: String
    let price: String
    var imageURL: String? = nil
    var onTap: (() -> Void)? = nil
    var isFavorite: Bool  
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.backgroundsSecondary)
            .frame(width: 177, height: 250)
    
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.fillsTertiary)
                        
                        if let imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable()
                                default:
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 44))
                                        .foregroundStyle(.fillsTertiary)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .allowsHitTesting(false)
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(.fillsTertiary)
                        }
                        
                        FavoriteIcon(isFavorite: isFavorite)
                    }
                    .frame(height: 161)
                
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.labelsPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.labelsPrimary)
                }
                .padding(8)
            )
            .onTapGesture { onTap?() }
    }
}

