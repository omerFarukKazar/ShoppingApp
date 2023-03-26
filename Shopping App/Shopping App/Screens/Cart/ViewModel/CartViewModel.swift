//
//  CartViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchCart()
}

struct CartViewModel {
    // MARK: - Properties
    weak var delegate: CartViewModelDelegate?
    var service: ProductsService?

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service as? ProductsService
    }
}

extension CartViewModel: FirestoreReadAndWritable {

    func fetchCart() {
        ProductsManager().fetchCart { error in
            if let error = error {
                self.delegate?.didErrorOccurred(error)
            } else {
                self.delegate?.didFetchCart()
            }
        }
    }
}

extension CartViewModel: DataDownloader {
    func downloadImageWith(_ urlString: String, completion: ((Data?, Error?) -> Void)?) {
        downloadDataWith(urlString, completion: completion)
    }
}

extension CartViewModel {
    func getSingleProduct(with id: Int, completion: @escaping ((Product?, Error?) -> Void)) {
        service?.getSingleProduct(with: id, completion: { result in
            switch result {
            case .success(let product):
                completion(product, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
