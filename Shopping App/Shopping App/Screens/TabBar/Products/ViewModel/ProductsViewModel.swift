//
//  ProductsViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 12.03.2023.
//

import Foundation

final class ProductsViewModel {
    // MARK: - Properties
    private var service: ProductsServiceable

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
