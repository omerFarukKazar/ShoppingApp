//
//  User.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.03.2023.
//

import Foundation

struct User: Codable {
    let username: String?
    let email: String?
    let birthday: String?
    var favorites: [Int]? = []
    var cart: [Int]? = []
}

extension User {
    // User is held as a dictionary at Firebase
    // This init method allows us to fetch and decode that dictionary into User struct.
    init(from dict: [String: Any]) {
        username = dict["username"] as? String
        email = dict["email"] as? String
        birthday = dict["birthday"] as? String
        favorites = dict["favorites"] as? [Int]
        cart = dict["cart"] as? [Int]
    }
}
