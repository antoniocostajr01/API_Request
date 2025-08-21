import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    @State private var selectedProduct: Product? = nil

    @EnvironmentObject var cart: CartStore


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
                            if let first = vm.products.first {
                                ProductHorizontal(
                                    category: first.category,
                                    title: first.title,
                                    price: String(format: "%.2f", first.price),
                                    imageURL: first.thumbnail,
                                    onTap: {
                                        vm.toggleIsFavorite(id: first.id)
                                        print(vm.getFavorites())
                                    }
                                )
                                .onTapGesture {
                                    selectedProduct = first
                                }
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
                                    price: String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", p.price),
                                    imageURL: p.thumbnail,
                                    isFavorite: vm.getFavorites().map { $0.id }.contains(p.id),
                                    onTap: {
                                        vm.toggleIsFavorite(id: p.id)
                                    }
                                )
                                .onTapGesture {
                                    selectedProduct = p
                                }
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

        .sheet(item: $selectedProduct) { product in
            ProductDetail(product: product)
            .presentationDragIndicator(.visible)
        }
        
        .environmentObject(cart)
        .sheet(item: $selectedProduct) { product in
            ProductDetail(product: product)
                .environmentObject(cart) 
                .presentationDragIndicator(.visible)
        }
    }
}

