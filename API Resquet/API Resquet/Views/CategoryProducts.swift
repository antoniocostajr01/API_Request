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
        ScrollView{
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.filteredProducts){product in
                    ProductVertical(title: product.title,
                                    price: "US$" + String(format: "%.2f", product.price),
                                    imageURL: product.thumbnail,
                                    onTap: { selectedProduct = product }

                    )
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

