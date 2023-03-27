//
//  ProfileViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didAppendToFavoriteProducts()
    func didErrorOccured(_ error: Error)

}

final class ProfileViewModel {
    // MARK: - Properties
    private var service: ProductsServiceable
    weak var delegate: ProfileViewModelDelegate?
    var favoriteProducts: Products = []

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
        getFavorites()
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }

    // MARK: - Methods

    func getFavorites() {
        ProductsManager.favorites.forEach { id in
            service.getSingleProduct(with: id) { result in
                switch result {
                case .failure(let error):
                    self.delegate?.didErrorOccured(error)
                case .success(let product):
                    self.favoriteProducts.append(product)
                    self.delegate?.didAppendToFavoriteProducts()
                }
            }
        }
    }
}
}
