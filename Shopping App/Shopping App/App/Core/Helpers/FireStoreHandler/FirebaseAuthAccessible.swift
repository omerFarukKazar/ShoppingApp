//
//  FirebaseAuthAccessible.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 28.03.2023.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthAccessible {}

extension FirebaseAuthAccessible {
    var auth: Auth {
        Auth.auth()
    }
}
