//
//  SearchViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 29.03.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didFetchProductsByCategory()
    func didErrorOccured(_ error: Error)
}

final class SearchViewModel {
    // MARK: - Properties
    var categories: Categories?
    var products: Products?
    let service: ProductsServiceable
    weak var delegate: SearchViewModelDelegate?

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
    }

    // MARK: - Methods
    func fetchAllProducts() {
        service.getProducts { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccured(error)
            case .success(let products):
                self.products = products
            }
        }
    }

    func fetchCategories() {
        service.getCategories { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccured(error)
            case .success(let categories):
                self.categories = categories
            }
        }
    }

    func fetchProductsBy(category: String) {
        service.getProductsInCategory(category: category) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccured(error)
            case .success(let products):
                self.products = products
                self.delegate?.didFetchProductsByCategory()
            }
        }
    }
    
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

extension SearchViewModel: DataDownloader {
    func fetchImageData(_ urlString: String, completion: @escaping ((Data?, Error?) -> Void)) {
        downloadDataWith(urlString) { imageData, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(imageData, nil)
            }
        }
    }
}
