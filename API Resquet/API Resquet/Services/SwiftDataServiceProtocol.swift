//
//  SwiftDataServiceProtocol.swift
//  API Resquet
//
//  Created by Antonio Costa on 25/08/25.
//

import Foundation

protocol SwiftDataServiceProtocol: SwiftDataService {
    
    func fetchOrder() -> [Order]
    func addOrder(order: Order)
    
    func fetchCart() -> [CartPersistence]
    func addProductToCart(product: CartPersistence)
    func deleteProductFromCart(product: CartPersistence)
    func updateCartQuantity(product: CartPersistence, newQuantity: Int)
    
    func fetchFavoriteProducts() -> [FavoriteProduct]
    func addFavoriteProduct(_ product: FavoriteProduct)
    func deleteFavoriteProduct(id: Int)
}
