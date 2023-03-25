//
//  ProductsViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 12.03.2023.
//

import Foundation
import FirebaseFirestore

/// Delegate protocol to handle possible outcomes from network calls.
protocol ProductsViewModelDelegate: AnyObject {
    func didFetchProducts()
    func didErrorOccured(_ error: Error)
}

final class ProductsViewModel: FireBaseFireStoreAccessible,
                               UserDefaultsAccessible {
    // MARK: - Properties
    private var service: ProductsServiceable
    weak var delegate: ProductsViewModelDelegate?

    lazy var products: Products = [] {
        didSet {
            delegate?.didFetchProducts()
        }
    }
//    lazy var favorites: [Int] = []

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
        fetchProducts()
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }

    // MARK: - Methods
    // MARK: Product Methods
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

    // MARK: Favorite Methods
    /// Fetch user's favorite products list from Firestore Database.
    /// If fetch failures, trigger the 'delegate.didErrorOccured'
    /// If fetch is success, assign that data to 'favorites' array in viewModel.
    func fetchFavoritesFromDB() {
        ProductsManager().fetchFavoritesFromDB { error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
            } else {
                self.delegate?.didFetchProducts()
            }
        }
    }

    // MARK: Color Method
    /// Takes the rate parameter and converts it into a CGFloat array to be used in initiating UIColor()
    /// - parameters:
    ///     - rate:: rate property of product that comes from API.
    /// - returns:
    ///     [CGFloat]: An array with size of four. Each element corresponds to
    ///    R, G, B, A values respectively.
    func setRatingViewBackgroundColor(withRespectTo rate: Double) -> [CGFloat] {
        switch rate {
        case 0...2.5:
            return [1.0, (rate / 2.5), 0.0, 1.0]
            // green value increases as the rate is increased.
            // green value is 0 when rate is 0;
            // green value is 1.0 when rate is 2.5
        case 2.5.nextUp...5:
            return [1.0 - ((rate - 2.5) / 2.5), 1.0, 0.0, 1.0]
            // red value decreases as the rate is increased.
            // substracted 2.5 from the rate to have smoother transition.
            // When rate is 3, red value is 0.8
            // When rate is 5, red value is 0.0
        default:
            return [1.0, 1.0, 1.0, 1.0]
        }
    }
}
// MARK: - Extensions
// MARK: Extension FirestoreReadAndWritable Protocol
extension ProductsViewModel: FirestoreReadAndWritable { }

// MARK: Extension DataDownloader Protocol
extension ProductsViewModel: DataDownloader {
    func downloadImageWith(_ urlString: String, completion: ((Data?, Error?) -> Void)?) {
        downloadDataWith(urlString, completion: completion)
    }
}
