//
//  Categories.swiftca
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Categories: View {
    @StateObject var viewModel = CategoryViewModel(service: DummyJSONService())
    
    var categorySelected: Category?

    
    var body: some View {
        VStack{
            HStack{
                ForEach(viewModel.randomCategories) {category in
                    VStack{
                        CategoryIcon(icon: category.localizedCategory?.symbolName ?? LocalizedCategory.beauty.symbolName )
                        Text(category.localizedCategory?.stringLocalized ?? LocalizedCategory.beauty.stringLocalized)
                            .lineLimit(1)
                            .font(.subheadline)
                            .fontWeight(.regular)
                    }
                }
            }
            .padding()
            
            List(viewModel.filteredCategories) { category in
                NavigationLink {
                    CategoryProducts(category: category)
                } label: {
                    Text(category.localizedCategory?.stringLocalized ?? "")
                        .padding(.vertical)
                }
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search")
        .navigationTitle(String(localized: "Categories", defaultValue: "Categories"))
        .task {
            await viewModel.load()
        }
        
    }
}

