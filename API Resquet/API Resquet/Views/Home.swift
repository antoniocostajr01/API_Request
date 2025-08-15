import SwiftUI

struct Home: View {
    @StateObject private var vm = HomeViewModel()

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
                
                if let deal = vm.deals.first {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Deals of the day")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundStyle(.primary)

                        ProductHorizontal(
                            category: deal.category,
                            title: deal.title,
                            price: String(format: "%.2f", deal.price),
                            imageURL: deal.thumbnail,
                            onTap: { vm.selectedProduct = deal },
                            isFavorite: false
                        )
                        .frame(width: 361, height: 176)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }

                if !vm.topPicks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top picks")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundStyle(.primary)

                        LazyVGrid(columns: vm.columns, spacing: 12) {
                            ForEach(vm.topPicks) { p in
                                ProductVertical(
                                    title: p.title,
                                    price: "US$" + String(format: "%.2f", p.price),
                                    imageURL: p.thumbnail,
                                    onTap: { vm.selectedProduct = p },
                                    isFavorite: false
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
        .sheet(item: $vm.selectedProduct) { product in
            ProductDetail(product: product)
                .presentationDragIndicator(.visible)
        }
    }
}


