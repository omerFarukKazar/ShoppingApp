//
//  ProductsEndpoint.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

/// Different endpoint cases
enum ProductsEndpoint {
    case product(id: Int)
    case products
    case categories // To be used in fast search buttons?
    case category(category: String) // It's possible to limit(Number) and sort(asc|desc) as query parameters.
}

/// Rest of the Endpoint for Products 
extension ProductsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .product(let id):
            return "/products/\(id)"
        case .products:
            return "/products"
        case .categories:
            return "/products/categories"
        case .category(let category):
            return "/products/category/\(category)"
        }
    }

    var queryItems: [String: String]? {
        return nil // If a different case needs to be added in the future, this can be changed with switch self block.
    }

    var method: RequestMethod {
        switch self {
        case .product, .products, .categories, .category:
            return .get
        }
    }

    var header: [String: String]? {
        return nil
    }

    var body: [String: String]? {
        return nil
    }
}
