//
//  FireStoreAccessible.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 18.03.2023.
//

import Foundation
import FirebaseFirestore

protocol FireBaseFireStoreAccessible {}

extension FireBaseFireStoreAccessible {
    // swiftlint:disable:next identifier_name
    var db: Firestore {
        Firestore.firestore()
    }
}
