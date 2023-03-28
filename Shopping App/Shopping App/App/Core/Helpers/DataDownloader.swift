//
//  DataDownloader.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 18.03.2023.
//

import Foundation

protocol DataDownloader {
    func downloadDataWith(_ urlString: String,
                           completion: ((_ imageData: Data?,
                                         _ error: Error?) -> Void)? )
}

extension DataDownloader {
    /// Takes a url input and sends dataTask request to that url.
    /// Handles the possible outcomes with completion.
    /// - parameters:
    ///     - urlString: String of the url for the desired image data.
    ///     - completion: Closure to handle data or error values.
    func downloadDataWith(_ urlString: String,
                           completion: ((_ imageData: Data?,
                                         _ error: Error?) -> Void)? ) {
        guard let url = URL(string: urlString) else {
            completion?(nil, NSError(domain: "fakestore.api", code: 400))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion?(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion?(nil, NSError(domain: "fakestore.api", code: httpResponse.statusCode))
                return
            }

            if let data = data {
                completion?(data, nil)
                return
            }
        }.resume()
    }
}
