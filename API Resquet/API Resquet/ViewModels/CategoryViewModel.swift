//
//  CategoyViewModel.swift
//  API Resquet
//
//  Created by Antonio Costa on 15/08/25.
//

import Foundation

@MainActor
final class CategoyViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var randomCategories: [Category] = []
    @Published var filteredCategories: [Category] = []
    
    @Published var searchText = ""{
        didSet{
            filterCategories()
        }
    }

    private let service: APIServicing

    init(service: APIServicing) {
        self.service = service
    }
    
    func loadRandomCategories() {
        randomCategories = Array(categories.shuffled().prefix(4))
    }
    
    func filterCategories() {
        guard !searchText.isEmpty else {
            filteredCategories = categories
            return
        }
        filteredCategories = categories.filter{ category in
            category.name.lowercased().contains(searchText.lowercased())
        }
    }
    

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            categories = try await service.fetchCategories()
            loadRandomCategories()
            filterCategories()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

