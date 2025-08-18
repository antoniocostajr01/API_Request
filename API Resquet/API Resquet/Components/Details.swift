import SwiftUI

struct Details: View {
    var imageURL: String? = nil
    @State private var isFavorite = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topTrailing) {
                if let imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                        default:
                            Image(systemName: "bag.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundStyle(.fillsTertiary)
                                .padding(100)
                                .background()
                        }
                    }
                 //   .clipShape(RoundedRectangle(cornerRadius: 8))
                    .allowsHitTesting(false)
                } else {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.fillsTertiary)
                        .padding(100)
                        .frame(width: 329, height: 329)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.fillsTertiary)
                        )
                        
                }
                FavoriteIcon(isFavorite: isFavorite, cornerRadius: 16, height: 50, width: 50, size: 28)
//                    .padding(.top, -9)
//                    .padding(.trailing, 16)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 32)
                .fill(.fillsTertiary)
             //   .frame(width: 361, height: 361))
                )
        }
    }
}
    #Preview {
        Details()
    }
    
