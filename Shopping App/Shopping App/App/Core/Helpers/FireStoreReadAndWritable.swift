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

/// Contains two methods to add and remove product in the specified document which is array  in Firestore
protocol FirestoreReadAndWritable: FireBaseFireStoreAccessible,
                                   UserDefaultsAccessible {

    func addProductTo(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void))
    func removeProductFrom(documentPath: String, withId id: Int?, completion: @escaping ((_ error: Error?) -> Void))
}

// TODO: Maybe some properties can be defined in protocol ( like "users" ) and
// a data type as a type of enum for the document type like array, int, string and returns the related function to user.
// That's how unexpected problems will be avoided.

extension FirestoreReadAndWritable {
    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and
    /// only adds or removes the id parameter to the **array** in Firebase.
    ///
    func addProductTo(documentPath: FirestoreDocumentPath.RawValue,
                      withId id: Int?,
                      completion: @escaping ((_ error: Error?) -> Void)) {
        let uid = UserDefaults.standard.string(forKey: "uid")
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

    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and only
    /// adds or removes the id parameter to the **array** in Firebase.
    func removeProductFrom(documentPath: FirestoreDocumentPath.RawValue,
                           withId id: Int?,
                           completion: @escaping ((_ error: Error?) -> Void)) {
        guard let id = id,
              let uid = uid else { return }
        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayRemove([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

}

// TODO: Maybe some properties can be defined in protocol ( like "users" )
// and a data type as a type of enum for the document type like array,
// int, string and returns the related function to user.
// enum FirestoreOperation {
//    case add
//    case remove
// }
//
// enum FirestoreCollections: String {
//    case users
// }
