//
//  Product.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 10.03.2023.
//

import Foundation

enum Category: String, Decodable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

typealias Products = [Product]

// MARK: - Product
struct Product: Decodable {
    let id: Int?
    let title: String?
    let price: Double?
    let description: String?
    let category: Category?
    let image: String?
    let rating: Rating?
}
// For this example, all the properties of Product are present in the model
// But i define them as optionals not to have unexpected issues in case of a missing property
