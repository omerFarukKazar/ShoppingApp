//
//  HTTPClient.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 11.03.2023.
//

import Foundation

// I was going to use async but since URLSession.shared.data(for: isn't supported below ios 15.0
// I seek for the ways to return result
// and i wanted to create class and return the result with delegate.
// After making a research i saw another example with closure as a completion.
// Maybe a delegation would look better. There is @escaping everywhere right now :)

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping ((Result<T, RequestError>) -> Void))
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type,
                                   completion: @escaping ((Result<T, RequestError>) -> Void)) {

        // Creating url components
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        // build url
        guard let url = urlComponents.url else {
            return completion(.failure(.invalidURL))
        }

        // define request type and attributes
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        // body if some private api key is needed
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        // URLSession
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.noResponse))
            }
            switch response.statusCode {
            case 200...299:
                guard let data = data,
                      let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return completion(.failure(.decode))
                }
                return completion(.success(decodedResponse))
            case 401:
                return completion(.failure(.unauthorized))
            case 403:
                return completion(.failure(.forbidden))
            case 404:
                return completion(.failure(.notFound))
            case 500...599:
                return completion(.failure(.serverError))
            default:
                return completion(.failure(.unexpectedStatusCode))
            }
        }.resume()
    }
}
