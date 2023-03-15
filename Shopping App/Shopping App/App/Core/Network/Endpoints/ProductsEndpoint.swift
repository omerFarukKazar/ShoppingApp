//
//  ProductsEndpoint.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

/// Different endpoint cases
enum ProductsEndpoint {
    case products
//    case productDetail(id: Int) // productDetail will be fetched if product cell tapped.
    // That'll save time, consume less data, decrease server side traffic.
    case categories // To be used in fast search buttons?
    case category // It's possible to limit(Number) and sort(asc|desc) as query parameters.
}

/// Rest of the Endpoint for Products 
extension ProductsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .categories:
            return "/categories"
        case .category:
            return "/products/category"
        }
    }

    var queryItems: [String: String]? {
        return nil // If a different case needs to be added in the future, this can be changed with switch self block.
    }

    var method: RequestMethod {
        switch self {
        case .products, .categories, .category:
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
