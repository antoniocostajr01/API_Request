
import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let error = vm.errorMessage {
                    Text(error).foregroundStyle(.red).padding(.horizontal)
                }
                
                if vm.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Deals of the day")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            if let firstElement = vm.products.first {
                                ProductHorizontal(
                                    category: firstElement.category,
                                    title: firstElement.title,
                                    price: String(format: "%.2f", firstElement.price),
                                    imageURL: firstElement.thumbnail
                                )
                                .frame(width: 361, height: 176)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                
                if !vm.products.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top picks")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(vm.products) { p in
                                ProductVertical(
                                    title: p.title,
                                    price: "US$" + String(format: "%.2f", p.price),
                                    imageURL: p.thumbnail
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Home")
        }
        .task { await vm.load() }
    }
}


