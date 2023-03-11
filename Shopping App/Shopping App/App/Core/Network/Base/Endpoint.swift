//
//  Endpoint.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

/// A protocol to set up all endpoints.
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [String: String]? { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

// This is the main url, so it won't change.
extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "fakestoreapi.com"
    }

}
