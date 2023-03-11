//
//  ProductsViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import UIKit

final class ProductsViewController: UIViewController {
    //TODO: Move to ViewModel
    var service: ProductsServiceable

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

    }

    // TODO: Move to ViewModel
    init(service: ProductsServiceable) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Remove the pilotMethod function.
    /// Function to try if generic network is working
    func pilotMethod() {
        service.getProducts(completion: { result in
            switch result {
            case .success(let products):
                print(products)
            case .failure(let error):
                print(error)
            }
        })
    }
}
