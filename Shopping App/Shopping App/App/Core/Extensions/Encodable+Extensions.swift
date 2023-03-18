//
//  Encodable+Extensions.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        get throws {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data,
                                                              options: .allowFragments) as? [String: Any]
            return dictionary
        }
    }
}
