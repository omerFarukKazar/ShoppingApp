//
//  ProfileViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import Foundation


final class ProfileViewModel {
    // MARK: - Properties
    private var service: ProductsServiceable
    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }
}
}
