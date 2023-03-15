//
//  ProductsViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 12.03.2023.
//

import Foundation

protocol ProductsViewModelDelegate: AnyObject {
    func didFetchProducts()
    func didErrorOccured(_ error: Error)
    func didFetchImage()
    func didAddToFavorites()
    func didRemoveFromFavorites()
}

final class ProductsViewModel {
    // MARK: - Properties
    private var service: ProductsServiceable
    weak var delegate: ProductsViewModelDelegate?

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }
    }

}
