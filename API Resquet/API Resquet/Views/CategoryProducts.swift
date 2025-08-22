//
//  CategoryProduct.swift
//  API Resquet
//
//  Created by Antonio Costa on 18/08/25.
//

import SwiftUI

struct CategoryProducts: View {
    
    @StateObject var viewModel: CategoryProductViewModel = CategoryProductViewModel(service: DummyJSONService())
    
    @State private var selectedProduct: Product? = nil

    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    let categorySelected: Category
    
    init(category: Category) {
        self.categorySelected = category
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    Group {
                        let currency = String(localized: "Currency", defaultValue: "US$")
                        let amount   = String(format: "%.2f", product.price)

                        ProductVertical(
                            title: product.title,
                            price: "\(currency) \(amount)",
                            imageURL: product.thumbnail,
                            onTap: { selectedProduct = product },
                            frame: CGRect(x: 0, y: 0, width: 177, height: 250)
                        )
                    }
                }
            }
        }
        .padding()
        .searchable(text: $viewModel.searchText, prompt: "Search")
        .navigationTitle(categorySelected.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProducts(category: categorySelected)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetail(product: product)
            .presentationDragIndicator(.visible)
                
        }
    }
}

