import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    @State private var selectedProduct: Product? = nil
    @EnvironmentObject var cart: CartStore

    // iPhone grid
    private let iPhoneColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // iPad: EXACT 2 across for Deals
    private let iPadDealsColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // iPad: EXACT 4 across
    private let iPadFourColumns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if vm.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }

                ViewThatFits {
                    // ===== iPad LANDSCAPE =====
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Deals of the day")
                            .font(.title2).fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: iPadDealsColumns, spacing: 16) {
                            ForEach(Array(vm.products.prefix(2))) { product in
                                ProductHorizontal(
                                    category: first.category,
                                    title: first.title,
                                    price: String(format: "%.2f", first.price),
                                    imageURL: first.thumbnail,
                                    isFavorite: vm.getFavorites().map { $0.id }.contains(first.id),
                                        onFavoriteTap: {
                                            vm.toggleIsFavorite(id: first.id)
                                        },
                                    onTap: {
                                        selectedProduct = first
                                    }

                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // ===== iPad PORTRAIT =====
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Deals of the day")
                            .font(.title2).fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: iPadDealsColumns, spacing: 16) {
                            ForEach(Array(vm.products.prefix(2))) { product in
                                ProductHorizontal(
                                    category: product.category,
                                    title: product.title,
                                    price: String(format: "%.2f", product.price),
                                    imageURL: product.thumbnail,
                                    onTap: {
                                        vm.toggleIsFavorite(id: product.id)
                                        selectedProduct = product
                                    },
                                    frame: CGRect(x: 0, y: 0, width: 377, height: 183)
                                )
                            }
                        }

                        Text("Top picks")
                            .font(.title2).fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: iPadFourColumns, spacing: 16) {
                            ForEach(Array(vm.products.prefix(4))) { p in
                                ProductVertical(
                                    title: p.title,
                                    price: String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", p.price),
                                    imageURL: p.thumbnail,
                                    isFavorite: vm.getFavorites().map { $0.id }.contains(p.id),
                                    onTap: {
                                        selectedProduct = p
                                        vm.toggleIsFavorite(id: p.id)
                                    },
                                    frame: CGRect(x: 0, y: 0, width: 181, height: 256)
                                )
                            }
                        }

                        Text("Best sellers")
                            .font(.title2).fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: iPadFourColumns, spacing: 16) {
                            ForEach(Array(vm.products.dropFirst(4))) { p in
                                ProductVertical(
                                    title: p.title,
                                    price: String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", p.price),
                                    imageURL: p.thumbnail,
                                    isFavorite: vm.getFavorites().map { $0.id }.contains(p.id),
                                    onTap: {
                                        selectedProduct = p

                                    },
                                    onFavoriteTap: {

                                        vm.toggleIsFavorite(id: p.id)
                                    },
                                    frame: CGRect(x: 0, y: 0, width: 181, height: 256)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // ===== iPhone fallback =====
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Deals of the day")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

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
                                            selectedProduct = first
                                        },
                                        frame: CGRect(x: 0, y: 0, width: 361, height: 176)
                                    )
                                    .onTapGesture { selectedProduct = first }
                                }
                            }
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if !vm.products.isEmpty {
                            Text("Top picks")
                                .font(.system(.title2, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            LazyVGrid(columns: iPhoneColumns, spacing: 12) {
                                ForEach(vm.products) { p in
                                    ProductVertical(
                                        title: p.title,
                                        price: String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", p.price),
                                        imageURL: p.thumbnail,
                                        isFavorite: vm.getFavorites().map { $0.id }.contains(p.id),
                                        onTap: {
                                            selectedProduct = p
                                            vm.toggleIsFavorite(id: p.id)
                                        },
                                        frame: CGRect(x: 0, y: 0, width: 177, height: 250)
                                    )
                                    .onTapGesture { selectedProduct = p }
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Home")
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .task { await vm.load() }
        .environmentObject(cart)
        .sheet(item: $selectedProduct) { product in
            ProductDetail(product: product)
                .environmentObject(cart)
                .presentationDragIndicator(.visible)
        }
    }
}

