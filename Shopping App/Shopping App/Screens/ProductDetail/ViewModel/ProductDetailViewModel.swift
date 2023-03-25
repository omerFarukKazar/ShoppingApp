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
    let product: Product
    lazy var favorites: [Int] = []

    // MARK: - Init
    init(product: Product) {
        self.product = product
    }
}

extension ProductDetailViewModel: FirestoreReadAndWritable { }
