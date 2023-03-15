//
//  ProductsViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 12.03.2023.
//

import Foundation
import FirebaseFirestore

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
    lazy var products: Products = [] {
        didSet {
            delegate?.didFetchProducts()
        }
    }
    weak var delegate: ProductsViewModelDelegate?
    private let db = Firestore.firestore()
    private let defaults = UserDefaults.standard
    lazy var favorites: [Int] = []

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
        fetchProducts()
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }
    /// Takes the indexpath parameter and returns the corresponding product.
    func productFor(_ indexPath: IndexPath) -> Product? {
        products[indexPath.row]
    }
    /// Fetches products from api and handles the possible responses.
    func fetchProducts() {
        service.getProducts(completion: { result in
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                self.delegate?.didErrorOccured(error)
            }
        })
    }

    /// Fetch user's favorite products list from Firestore Database.
    /// If fetch failures, trigger the 'delegate.didErrorOccured'
    /// If fetch is success, assign that data to 'favorites' array in viewModel.
    func fetchFavoritesFromDB() {
        let uid = defaults.string(forKey: "uid")
        guard let uid = uid else { return }
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
                return
            } else {
                if let data = snapshot?.data() {
                    let dataAsInt = data["favorites"] as? [Int]
                    guard let dataAsInt = dataAsInt else { return }
                    self.favorites = dataAsInt
                }
            }
        }
    }

    }

}
