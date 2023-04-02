//
//  ProductsService.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

protocol ProductsServiceable {
    func getProducts(completion: @escaping ((Result<Products, RequestError>) -> Void))
    func getSingleProduct(with id: Int,
                          completion: @escaping ((Result<Product, RequestError>) -> Void))
    func getCategories(completion: @escaping ((Result<[String], RequestError>) -> Void))
    func getSpecificCategory(category: String,
                             completion: @escaping ((Result<Products, RequestError>) -> Void))
}

/// Contains a method that sends a request to get products.
/// - Conforms to protocols:
///     - HTTPClient
///     - ProductsServiceable
struct ProductsService: HTTPClient, ProductsServiceable {
    /**
     Fetches all the categories with an URL Request.

     - parameters:
        - completion:: Takes Result as a parameter, it's used to handle possible result cases.
     */
    func getCategories(completion: @escaping ((Result<[String], RequestError>) -> Void)) {
        return sendRequest(endpoint: ProductsEndpoint.categories,
                           responseModel: [String].self,
                           completion: completion)
    }

    /**
     Fetches the products in specified category with an URL Request.

     - parameters:
        - category:: Category for the related products.
        - completion:: Takes Result as a parameter, it's used to handle possible result cases.
     */
    func getSpecificCategory(category: String, completion: @escaping ((Result<Products, RequestError>) -> Void)) {
        return sendRequest(endpoint: ProductsEndpoint.category(category: category),
                           responseModel: Products.self,
                           completion: completion)
    }

    /**
     Fetches the single product with an URL Request.

     - parameters:
        - id:: id of the product
        - completion:: Takes Result as a parameter, it's used to handle possible result cases.
     */
    func getSingleProduct(with id: Int, completion: @escaping ((Result<Product, RequestError>) -> Void)) {
        return sendRequest(endpoint: ProductsEndpoint.product(id: id),
                           responseModel: Product.self,
                           completion: completion)
    }

    /// Sends a request by using HTTPClient method.
    /// That request is adapted to get Products.
    /// - parameters:
    ///     - completion: The closure that'll be passed to HTTPClient to conform and handle the possible results.
    func getProducts(completion: @escaping ((Result<Products, RequestError>) -> Void)) {
        return sendRequest(endpoint: ProductsEndpoint.products,
                           responseModel: Products.self,
                           completion: completion)
    }

}
