//
//  Categories.swift
//  API Resquet
//
//  Created by Antonio Costa on 15/08/25.
//

import Foundation

struct Category: Decodable, Identifiable {
    var slug: String
    var name: String
    var url: String
    var id: String{
        return slug
    }
    var localizedCategory: LocalizedCategory? {
          return LocalizedCategory(rawValue: name)
      }
}

enum LocalizedCategory: String, CaseIterable {
    case beauty = "Beauty"
    case fragrances = "Fragrances"
    case furniture = "Furniture"
    case groceries = "Groceries"
    case homeDecoration = "Home Decoration"
    case kitchenAccesories = "Kitchen Accessories"
    case laptops = "Laptops"
    case mensShirts = "Mens Shirts"
    case mensShoes = "Mens Shoes"
    case mensWatches = "Mens Watches"
    case mobileAccessories = "Mobile Accessories"
    case motorcycle = "Motorcycle"
    case skinCare = "Skin Care"
    case smartphones = "Smartphones"
    case sportsAccessories = "Sports Accessories"
    case sunglasses = "Sunglasses"
    case tablets = "Tablets"
    case tops = "Tops"
    case vehicle = "Vehicle"
    case womensBags = "Womens Bags"
    case womensDresses = "Womens Dresses"
    case womensJewellery = "Womens Jewellery"
    case womensShoes = "Womens Shoes"
    case womensWatches = "Womens Watches"
    
    var stringLocalized: String {
        switch self {
        case .beauty:
            return String(localized: "Beauty")
        case .fragrances:
            return String(localized: "Fragrances")
        case .furniture:
            return String(localized: "Furniture")
        case .groceries:
            return String(localized: "Groceries")
        case .homeDecoration:
            return String(localized: "Home Decoration")
        case .kitchenAccesories:
            return String(localized: "Kitchen accessories")
        case .laptops:
            return String(localized: "Laptops")
        case .mensShirts:
            return String(localized: "Mens shirts")
        case .mensShoes:
            return String(localized: "Mens Shoes")
        case .mensWatches:
            return String(localized: "Mens watches")
        case .mobileAccessories:
            return String(localized: "Mobile accessories")
        case .motorcycle:
            return String(localized: "Motorcycle")
        case .skinCare:
            return String(localized: "Skincare")
        case .smartphones:
            return String(localized: "Smartphones")
        case .sportsAccessories:
            return String(localized: "Sports accessories")
        case .sunglasses:
            return String(localized: "Sunglasses")
        case .tablets:
            return String(localized: "Tablets")
        case .tops:
            return String(localized: "Tops")
        case .vehicle:
            return String(localized: "Vehicle")
        case .womensBags:
            return String(localized: "Womens bags")
        case .womensDresses:
            return String(localized: "Womens dresses")
        case .womensJewellery:
            return String(localized: "Womens jewellery")
        case .womensShoes:
            return String(localized: "Womens shoes")
        case .womensWatches:
            return String(localized: "Womens watches")
        }
    }
}
