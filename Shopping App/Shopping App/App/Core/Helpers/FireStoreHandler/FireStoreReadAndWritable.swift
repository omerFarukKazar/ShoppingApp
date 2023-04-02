//
//  FireStoreReadAndWritable.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 18.03.2023.
//

import Foundation
import FirebaseFirestore

enum FirestoreDocumentPath: String {
    case favorites
    case cart
}

enum CartOperation {
    case increase
    case decrease
    case remove
}

enum CollectionPath: String {
    case users
}

/// Contains two methods to add and remove product in the specified document which is array  in Firestore
protocol FirestoreReadAndWritable: FireBaseFireStoreAccessible,
                                   UserDefaultsAccessible {

    func fetchUserData(completion: @escaping ((_ userData: User?, _ error: Error?) -> Void))

    func addToFavorites(with productId: Int?,
                        completion: @escaping ((_ error: Error?) -> Void))
    func removeFromFavorites(with productId: Int?,
                             completion: @escaping ((_ error: Error?) -> Void))
    func updateCart(with operation: CartOperation,
                    productId: Int?,
                    completion: @escaping ((_ error: Error?) -> Void))

}

extension FirestoreReadAndWritable {

    func fetchUserData(completion: @escaping ((_ userData: User?, _ error: Error?) -> Void)) {
        guard let uid = uid else { return }

        let users = CollectionPath.users.rawValue

        db.collection(users).document(uid).getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let document = document?.data() else { return }
                let user = User(from: document)
                completion(user, nil)
            }
        }
    }
    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and
    /// only adds or removes the id parameter to the **array** in Firebase.
    ///
    func updateCart(with operation: CartOperation,
                    productId: Int?,
                    completion: @escaping ((_ error: Error?) -> Void)) {

        let cartBackup = ProductsManager.cart

        guard let id = productId,
              let uid = uid else { return }

        switch operation {
        case .increase:
            if let count = ProductsManager.cart[id] {
                ProductsManager.cart.updateValue(count + 1, forKey: id)
            } else {
                ProductsManager.cart.updateValue(1, forKey: id)
            }

        case .decrease:
            if let count = ProductsManager.cart[id] {
                if count == 1 {
                    ProductsManager.cart.removeValue(forKey: id)
                } else {
                    ProductsManager.cart.updateValue(count - 1, forKey: id)
                }
            }
        case .remove:
            if let count = ProductsManager.cart[id] {
                ProductsManager.cart.removeValue(forKey: id)
            }
        }

        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(ProductsManager.cart)
        } catch {
            ProductsManager.cart = cartBackup
            completion(error)
        }

        let documentPath = FirestoreDocumentPath.cart.rawValue

        db.collection("users").document(uid).updateData([documentPath: jsonData]) { error in
            if let error = error {
                ProductsManager.cart = cartBackup
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and only
    /// adds or removes the id parameter to the **array** in Firebase.
    func addToFavorites(with productId: Int?,
                        completion: @escaping ((_ error: Error?) -> Void)) {

        guard let id = productId,
              let uid = uid else { return }

        let documentPath = FirestoreDocumentPath.favorites.rawValue

        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayUnion([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                ProductsManager.favorites.append(id)
                completion(nil)
            }
        }
    }

    func removeFromFavorites(with productId: Int?, completion: @escaping ((_ error: Error?) -> Void)) {

        guard let id = productId,
              let uid = uid else { return }

        let documentPath = FirestoreDocumentPath.favorites.rawValue

        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayRemove([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                guard let index = ProductsManager.favorites.firstIndex(of: id) else { return }
                ProductsManager.favorites.remove(at: index)
                completion(nil)
            }
        }
    }

}
