//
//  ProfileViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import Foundation
import CoreData

protocol ProfileViewModelDelegate: AnyObject {
    func didAppendToFavoriteProducts()
    func didErrorOccured(_ error: Error)
    func didFetchUserData()
    func didUploadImage(_ downloadUrl: URL)
    func didGetUserImageData(_ imageData: Data)
}

final class ProfileViewModel {
    // MARK: - Properties
    private var service: ProductsServiceable
    weak var delegate: ProfileViewModelDelegate?
    var favoriteProducts: Products = []
    var user: User = User(from: [:])
    var imageUrl = URL(string: "")

    // MARK: - Init
    init(service: ProductsServiceable) {
        self.service = service
        getFavorites()
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoder not found.")
    }

    // MARK: - Methods
    func getFavorites() {
        ProductsManager.favorites.forEach { id in
            service.getSingleProduct(with: id) { result in
                switch result {
                case .failure(let error):
                    self.delegate?.didErrorOccured(error)
                case .success(let product):
                    self.favoriteProducts.append(product)
                    self.delegate?.didAppendToFavoriteProducts()
                }
            }
        }
    }
}

// MARK: - Protocol DataDownloader
extension ProfileViewModel: DataDownloader {
    func downloadImageData(with imageUrl: String, completion: @escaping ((_ imageData: Data?, _ error: Error?) -> Void)) {

        downloadDataWith(imageUrl) { imageData, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = imageData else { return }
                completion(data, nil)
            }
        }
    }
}

// MARK: - Protocol FirestoreReadAndWritable
extension ProfileViewModel: FirestoreReadAndWritable {
    func getUserData() {
        fetchUserData { userData, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
            } else {
                guard let userData = userData else { return }
                self.user = userData
                self.delegate?.didFetchUserData()
            }
        }
    }
}

// MARK: - Protocol FirebaseStorable
extension ProfileViewModel: FirebaseStorable {
    func uploadProfilePhoto(with imageData: Data) {
        upload(imageData: imageData) { url, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
            } else {
                guard let url = url else { return }
                self.delegate?.didUploadImage(url)
            }
        }
    }
}

// MARK: - Protocol CoreDataManager
extension ProfileViewModel: CoreDataManager {
    func getUserImageData(entityName: String, attributeName: String) {
        getDataFromCoreData(entityName: entityName, attributeName: attributeName) { data, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
            } else {
                guard let data = data as? Data else { return }
                self.delegate?.didGetUserImageData(data)
            }
        }
    }

    func saveImageData(data: Data, entityName: String, attributeName: String) {
        do {
            try saveToCoreData(data: data, entityName: entityName, attributeName: attributeName)
        } catch {
            self.delegate?.didErrorOccured(error)
        }
    }
}
