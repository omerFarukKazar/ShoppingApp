//
//  User.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.03.2023.
//

import Foundation

struct User: Codable {
    let username: String?
    let mail: String?
    let password: String?
    let birthday: String?
}

extension User {
    // User is held as a dictionary at Firebase
    // This init method allows us to fetch and decode that dictionary into User struct.
    init(from dict: [String: Any]) {
        username = dict["username"] as? String
        mail = dict["mail"] as? String
        password = dict["password"] as? String
        birthday = dict["birthday"] as? String
    }
}
