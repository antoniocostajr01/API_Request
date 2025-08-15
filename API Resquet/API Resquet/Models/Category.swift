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
}
