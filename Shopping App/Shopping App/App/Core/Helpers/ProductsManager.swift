//
//  CartViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import Foundation

final class ProductsManager {
    static let products = ProductsManager()
    static var cart: [Int: Int] = [:]
    static var favorites: [Int] = []
}

extension ProductsManager: FireBaseFireStoreAccessible,
                           UserDefaultsAccessible {

    func fetchCart(completion: @escaping ((_ error: Error?) -> Void) ) {
        guard let uid = uid else { return }
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(error)
                return
            } else {
                guard let data = snapshot?.data(),
                      let cartData = data["cart"] as? Data else { return }
                do {
                    let cart = try JSONDecoder().decode(Dictionary<Int, Int>.self,
                                                        from: cartData)
                    ProductsManager.cart = cart
                } catch {
                    completion(error)
                }
            }
        }
    }

    func fetchFavoritesFromDB(completion: @escaping ((_ error: Error?) -> Void)) {
        guard let uid = uid else { return }
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(error)
                return
            } else {
                if let data = snapshot?.data() {
                    let dataAsInt = data["favorites"] as? [Int]
                    guard let dataAsInt = dataAsInt else { return }
                    ProductsManager.favorites = dataAsInt
                }
            }
        }
    }
}
