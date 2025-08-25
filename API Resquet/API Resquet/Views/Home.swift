import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    @State private var selectedProduct: Product? = nil
    @EnvironmentObject var cart: CartViewModel

    // iPhone grid
    private let iPhoneColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // iPad: 2 for Deals
    private let iPadDealsColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // iPad:  4 across
    private let iPadFourColumns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    private var currencyPrefix: String { String(localized: "Currency", defaultValue: "US$") }
    private var favoriteIDs: Set<Int> { Set(vm.getFavorites().map { $0.id }) }

    private func priceText(_ value: Double) -> String {
        currencyPrefix + " " + String(format: "%.2f", value)
    }

    private func isFav(_ id: Int) -> Bool {
        favoriteIDs.contains(id)
    }

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
                    // iPad LANDSCAPE
                    iPadLandscapeSection
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // iPad PORTRAIT
                    iPadPortraitSection
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // iPhone
                    iPhoneSection
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


    private var iPadLandscapeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Deals of the day")
                .font(.title2).fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: iPadDealsColumns, spacing: 16) {
                if let first = vm.products.first {
                    let count = min(2, vm.products.count)
                    ForEach(0..<count, id: \.self) { idx in
                        ProductHorizontal(
                            category: first.category,
                            title: first.title,
                            price: priceText(first.price),
                            imageURL: first.thumbnail,
                            isFavorite: isFav(first.id),
                            onFavoriteTap: { vm.toggleIsFavorite(id: first.id) },
                            onTap: { selectedProduct = first },
                            frame: CGRect(x: 0, y: 0, width: 557, height: 271)
                        )
                        .id("deal-\(idx)")
                    }
                }
            }
        }
    }

    private var iPadPortraitSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Deals of the day")
                .font(.title2).fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: iPadDealsColumns, spacing: 16) {
                if let first = vm.products.first {
                    let count = min(2, vm.products.count)
                    ForEach(0..<count, id: \.self) { idx in
                        ProductHorizontal(
                            category: first.category,
                            title: first.title,
                            price: priceText(first.price),
                            imageURL: first.thumbnail,
                            isFavorite: isFav(first.id),
                            onFavoriteTap: { vm.toggleIsFavorite(id: first.id) },
                            onTap: { selectedProduct = first },
                            frame: CGRect(x: 0, y: 0, width: 377, height: 183)
                        )
                        .id("deal-\(idx)")
                    }
                }
            }

            Text("Top picks")
                .font(.title2).fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: iPadFourColumns, spacing: 16) {
                ForEach(Array(vm.products.prefix(4))) { p in
                    ProductVertical(
                        title: p.title,
                        price: priceText(p.price),
                        imageURL: p.thumbnail,
                        isFavorite: isFav(p.id),
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

            Text("Best sellers")
                .font(.title2).fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: iPadFourColumns, spacing: 16) {
                ForEach(Array(vm.products.dropFirst(4))) { p in
                    ProductVertical(
                        title: p.title,
                        price: priceText(p.price),
                        imageURL: p.thumbnail,
                        isFavorite: isFav(p.id),
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
    }

    // iPhone
    private var iPhoneSection: some View {
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
                            price: priceText(first.price),
                            imageURL: first.thumbnail,
                            isFavorite: isFav(first.id),
                            onFavoriteTap: { vm.toggleIsFavorite(id: first.id) },
                            onTap: { selectedProduct = first },
                            frame: CGRect(x: 0, y: 0, width: 361, height: 176)
                        )
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
                            price: priceText(p.price),
                            imageURL: p.thumbnail,
                            isFavorite: isFav(p.id),
                            onTap: { selectedProduct = p },
                            onFavoriteTap: { vm.toggleIsFavorite(id: p.id) },
                            frame: CGRect(x: 0, y: 0, width: 177, height: 250)
                        )
                    }
                }
                .padding(.top, 8)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
