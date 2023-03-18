//
//  CartViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import Foundation

final class ProductsManager {
    static let products = ProductsManager()
    static var cart: [Int: Int] = [:]
    static var favorites: [Int] = []
}
