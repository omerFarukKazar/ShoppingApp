//
//  UserDefaultsAccessible.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 18.03.2023.
//

import Foundation

enum UserDefaultConstants: String {
    case uid
}

protocol UserDefaultsAccessible {}

extension UserDefaultsAccessible {
    var defaults: UserDefaults {
        UserDefaults.standard
    }

    var uid: String? {
        stringDefault(for: .uid)
    }

    func stringDefault(for key: UserDefaultConstants) -> String? {
        defaults.string(forKey: key.rawValue)
    }
}
