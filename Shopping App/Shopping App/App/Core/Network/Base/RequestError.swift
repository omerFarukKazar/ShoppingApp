//
//  RequestError.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

/// Server side Error cases
enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unexpectedStatusCode
    case unknown

    /// Returns the error message as a string of related RequestError case.
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "Server doesn't respond at the time."
        case .unauthorized:
            return "You are not allowed to access."
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .serverError:
            return "Server Error"
        default:
            return "Unknown internet error"
        }
    }
}
