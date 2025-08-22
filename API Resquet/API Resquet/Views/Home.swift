//import SwiftUI
//
//struct Home: View {
//    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
//    @State private var selectedProduct: Product? = nil
//    @EnvironmentObject var cart: CartStore
//
//    private let columns: [GridItem] = [
//        GridItem(.flexible(), spacing: 12),
//        GridItem(.flexible(), spacing: 12)
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                if let error = vm.errorMessage {
//                    Text(error).foregroundStyle(.red).padding(.horizontal)
//                }
//
//                if vm.isLoading {
//                    ProgressView("Loading…")
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .padding()
//                }
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Deals of the day")
//                        .font(.system(.title2, weight: .semibold))
//                        .foregroundStyle(.primary)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 12) {
//                            if let first = vm.products.first {
//                                ProductHorizontal(
//                                    category: first.category,
//                                    title: first.title,
//                                    price: String(format: "%.2f", first.price),
//                                    imageURL: first.thumbnail,
//                                    onTap: { selectedProduct = first }
//                                )
//                                .frame(width: 361, height: 176)
//                            }
//                        }
//                        .padding(.vertical, 4)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top)
//
//                if !vm.products.isEmpty {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Top picks")
//                            .font(.system(.title2, weight: .semibold))
//                            .foregroundStyle(.primary)
//
//                        LazyVGrid(columns: columns, spacing: 12) {
//                            ForEach(vm.products) { p in
//                                ProductVertical(
//                                    title: p.title,
//                                    price: String(localized: "Currency", defaultValue: "US$") + " " + String(format: "%.2f", p.price),
//                                    imageURL: p.thumbnail,
//                                    onTap: { selectedProduct = p }
//                                )
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//                    .padding(.bottom)
//                }
//            }
//            .navigationTitle("Home")
//        }
//        .task { await vm.load() }
//
//        .sheet(item: $selectedProduct) { product in
//            ProductDetail(product: product)
//            .presentationDragIndicator(.visible)
//        }
//        
//        .environmentObject(cart)
//        .sheet(item: $selectedProduct) { product in
//            ProductDetail(product: product)
//                .environmentObject(cart) 
//                .presentationDragIndicator(.visible)
//        }
//    }
//}
//

import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    @State private var selectedProduct: Product? = nil
    @EnvironmentObject var cart: CartStore

    // iPhone columns
    private let iPhoneColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // iPad columns
    private let iPadDealsColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private let iPadColumns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    private let iPadHorizontalColumns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    // Derived properties
    private var dealOfTheDay: Product? { vm.products.first }
    private var iPadDealsOfTheDay: [Product] { Array(vm.products.prefix(2)) }
    private var iPadTopPicks: [Product] { Array(vm.products.sorted { $0.title < $1.title }.prefix(4)) }
    private var iPadBestSellers: [Product] { Array(vm.products.sorted { $0.title > $1.title }.dropFirst(4)) }

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

                ViewThatFits {

                    // 👉 Horizontal iPad layout
                    VStack(alignment: .leading, spacing: 16) {
                        if !iPadDealsOfTheDay.isEmpty {
                            LazyVGrid(columns: iPadDealsColumns, spacing: 0) {
                                ForEach(iPadDealsOfTheDay) { product in
                                    Button { selectedProduct = product } label: {
                                        ProductHorizontal(
                                            category: product.category,
                                            title: product.title,
                                            price: String(format: "%.2f", product.price),
                                            imageURL: product.thumbnail,
                                            onTap: { selectedProduct = product }
                                        )
                                        .frame(width: 377, height: 183)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Top picks")
                                .font(.title2).fontWeight(.bold)

                            LazyVGrid(columns: iPadHorizontalColumns, spacing: 16) {
                                ForEach(vm.products) { p in
                                    Button { selectedProduct = p } label: {
                                        ProductVertical(
                                            title: p.title,
                                            price: "US$ " + String(format: "%.2f", p.price),
                                            imageURL: p.thumbnail,
                                            onTap: { selectedProduct = p }
                                        )
                                        .frame(width: 181, height: 256)
                                    }
                                }
                            }
                        }
                    }

                    // 👉 Wide iPad layout
                    VStack(alignment: .leading, spacing: 16) {
                        if !iPadDealsOfTheDay.isEmpty {
                            LazyVGrid(columns: iPadDealsColumns, spacing: 0) {
                                ForEach(iPadDealsOfTheDay) { product in
                                    Button { selectedProduct = product } label: {
                                        ProductHorizontal(
                                            category: product.category,
                                            title: product.title,
                                            price: String(format: "%.2f", product.price),
                                            imageURL: product.thumbnail,
                                            onTap: { selectedProduct = product }
                                        )
                                        .frame(width: 377, height: 183)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Top picks")
                                .font(.title2).fontWeight(.bold)

                            LazyVGrid(columns: iPadColumns, spacing: 16) {
                                ForEach(iPadTopPicks) { p in
                                    Button { selectedProduct = p } label: {
                                        ProductVertical(
                                            title: p.title,
                                            price: "US$ " + String(format: "%.2f", p.price),
                                            imageURL: p.thumbnail,
                                            onTap: { selectedProduct = p }
                                        )
                                        .frame(width: 181, height: 256)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Best Sellers")
                                .font(.title2).fontWeight(.bold)

                            LazyVGrid(columns: iPadColumns, spacing: 16) {
                                ForEach(iPadBestSellers) { p in
                                    Button { selectedProduct = p } label: {
                                        ProductVertical(
                                            title: p.title,
                                            price: "US$ " + String(format: "%.2f", p.price),
                                            imageURL: p.thumbnail,
                                            onTap: { selectedProduct = p }
                                        )
                                        .frame(width: 181, height: 256)
                                    }
                                }
                            }
                        }
                    }

                    // 👉 Fallback iPhone layout
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Deals of the Day")
                            .font(.title2).fontWeight(.bold)

                        if let deal = dealOfTheDay {
                            Button { selectedProduct = deal } label: {
                                ProductHorizontal(
                                    category: deal.category,
                                    title: deal.title,
                                    price: String(format: "%.2f", deal.price),
                                    imageURL: deal.thumbnail,
                                    onTap: { selectedProduct = deal }
                                )
                                .frame(width: 377, height: 183)
                            }
                        }

                        Text("Top picks")
                            .font(.title2).fontWeight(.bold)

                        LazyVGrid(columns: iPhoneColumns, spacing: 12) {
                            ForEach(vm.products) { p in
                                Button { selectedProduct = p } label: {
                                    ProductVertical(
                                        title: p.title,
                                        price: "US$ " + String(format: "%.2f", p.price),
                                        imageURL: p.thumbnail,
                                        onTap: { selectedProduct = p }
                                    )
                                    .frame(width: 181, height: 256)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Home")
        }
        .task { await vm.load() }
        .sheet(item: $selectedProduct) { product in
            ProductDetail(product: product)
                .environmentObject(cart)
                .presentationDragIndicator(.visible)
        }
    }
}
