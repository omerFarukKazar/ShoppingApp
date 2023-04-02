//
//  ProductDetailViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import Foundation
import FirebaseFirestore

struct ProductDetailViewModel {
    // MARK: - Properties
    var service: ProductsServiceable?
    var productsInCart: Products?
    let product: Product
    lazy var favorites: [Int] = []

    // MARK: - Init
    init(product: Product, service: ProductsServiceable) {
        self.product = product
        self.service = service
    }
}

extension ProductDetailViewModel: FirestoreReadAndWritable { }

extension ProductDetailViewModel { }
