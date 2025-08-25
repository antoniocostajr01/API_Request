//
//  OrdersItem.swift
//  API Resquet
//
//  Created by sofia leitao on 20/08/25.
//

import Foundation
import SwiftUI

@MainActor
class OrderViewModel: ObservableObject {
    @Published var items: [Order] = []
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    
    private let dataSource: SwiftDataService
    private let service: APIServicing
    
    private var deliveryFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "MMMM, dd"
        return f
    }
    
    
    init(dataSource: SwiftDataService, service: APIServicing ) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func loadPersistence() async {
        print("OrderService shared instance: \(SwiftDataService.shared)")
        isLoading = true
        items  = dataSource.fetchOrder()
        
        products = try! await service.fetchProducts()
    
        isLoading = false
    }
    
    func getElementById(id: Int) -> Product {
        products.first(where: { $0.id == id }) ?? Product(id: 0, title: "", description: nil, category: "", price: 0, brand: nil, thumbnail: nil)
    }
    
    func eta(orderDate: Date) -> String {
        let text = String(localized: "DELIVERY BY: ")
        return text+(deliveryFormatter.string(from: orderDate)).uppercased()
    }
    
    
    func save(items: [CartPersistence]) {
        
        let ids = Set(items.map{$0.id})
        let filteredItems = products.filter{ids.contains($0.id)}
        
        for productsFilter in filteredItems {
            for item in items {
                if productsFilter.id == item.id {
                    let orderItem = Order(
                        id: item.id,
                        amount: Double(productsFilter.price) * Double(item.quantity),
                        date: Date().addingTimeInterval(60 * 60 * 24 * 7)
                     )
                    
                    dataSource.addOrder(order: orderItem)
                }
            }
        }
    }
    
    func clear() {
        items.removeAll()
    }
}
