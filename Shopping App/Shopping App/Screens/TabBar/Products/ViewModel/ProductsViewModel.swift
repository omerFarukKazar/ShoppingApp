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

    /// Takes a url input and sends dataTask request to that url.
    /// Handles the possible outcomes with completion.
    /// - parameters:
    ///     - urlString: String of the url for the desired image data.
    ///     - completion: Closure to handle data or error values.
    func downloadImageData(_ urlString: String,
                           completion: ((_ imageData: Data?, _ error: Error?) -> Void)? ) {
        guard let url = URL(string: urlString) else {
            completion?(nil, NSError(domain: "fakestore.api", code: 400))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion?(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion?(nil, NSError(domain: "fakestore.api", code: httpResponse.statusCode))
                return
            }

            if let data = data {
                completion?(data, nil)
                return
            }
        }.resume()
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

    // At first i thought about storing this in CoreData but
    // if user would like to access favorites from another device or another platform
    // it wouldn't be possible. So i choose to store that in server side.
    /// Accesses FireStore database with user's uid stored in defaults and adds product's id to favorites array that is stored in firestore db.
    /// - parameters:
    ///     - id:: The id of the product whose Favorite button was tapped on.
    func addToFavoritesWith(id: Int?, completion: @escaping (() -> Void)) {
        let uid = defaults.string(forKey: "uid")
        guard let id = id,
              let uid = uid else { return }
        db.collection("users").document(uid).updateData(["favorites": FieldValue.arrayUnion([id])]) { error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
                return
            } else {
                self.delegate?.didAddToFavorites()
                completion()
            }
        }
    }

    /// Accesses FireStore database with user's uid stored in defaults and removes the product's id from favorites array that is stored in firestore db.
    /// - parameters:
    ///     - id:: The id of the product whose Favorite button was tapped on.
    func removeFromFavoritesWith(id: Int?, completion: @escaping (() -> Void)) {
        let uid = defaults.string(forKey: "uid")
        guard let id = id,
              let uid = uid else { return }
        db.collection("users").document(uid).updateData(["favorites": FieldValue.arrayRemove([id])]) { error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
                return
            } else {
                self.delegate?.didRemoveFromFavorites()
                completion()
            }
        }
    }

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
