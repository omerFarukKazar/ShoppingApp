//
//  ProductViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import Foundation
import FirebaseFirestore

enum FirestoreDocumentPath: String {
    case favorites
    case cart
}

protocol FirestoreReadWritable {
    func addProductTo(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void))
    func removeProductFrom(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void))
}

extension FirestoreReadWritable {
    func addProductTo(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void)) {
        let uid = UserDefaults.standard.string(forKey: "uid")
        let db = Firestore.firestore()
        guard let id = id,
              let uid = uid else { return }
        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayUnion([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

    func removeProductFrom(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void)) {
        let uid = UserDefaults.standard.string(forKey: "uid")
        let db = Firestore.firestore()
        guard let id = id,
              let uid = uid else { return }
        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayUnion([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
}

struct ProductViewModel {
    // MARK: - Properties
    let product: Product
    lazy var favorites: [Int] = []
    // MARK: - Init
    init(product: Product) {
        self.product = product
    }

}
