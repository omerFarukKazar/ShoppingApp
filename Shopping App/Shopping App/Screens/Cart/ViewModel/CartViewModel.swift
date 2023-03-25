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
    weak var delegate: CartViewModelDelegate?
    var service: ProductsService?
    init(service: ProductsServiceable) {
        self.service = service as? ProductsService
    }
}

extension CartViewModel: UserDefaultsAccessible,
                         FireBaseFireStoreAccessible {

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


}
