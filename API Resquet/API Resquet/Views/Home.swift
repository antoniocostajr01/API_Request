import SwiftUI

struct Home: View {
<<<<<<< HEAD:API Resquet/API Resquet/Views/Home.swift
    @StateObject private var vm = HomeViewModel()

=======
    @StateObject private var vm = HomeViewModel(service: DummyJSONService())
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
>>>>>>> main:API Resquet/API Resquet/Home.swift
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
                
<<<<<<< HEAD:API Resquet/API Resquet/Views/Home.swift
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
=======
                
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
>>>>>>> main:API Resquet/API Resquet/Home.swift
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                
                if !vm.products.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top picks")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundStyle(.primary)
<<<<<<< HEAD:API Resquet/API Resquet/Views/Home.swift

                        LazyVGrid(columns: vm.columns, spacing: 12) {
                            ForEach(vm.topPicks) { p in
=======
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(vm.products) { p in
>>>>>>> main:API Resquet/API Resquet/Home.swift
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


