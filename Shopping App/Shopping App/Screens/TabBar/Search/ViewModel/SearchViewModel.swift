//
//  SearchViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 29.03.2023.
//

import Foundation

final class SearchViewModel {
    // MARK: - Properties
    var products: Products?
    let service: ProductsServiceable

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
    }

    // MARK: - Methods
    
}

