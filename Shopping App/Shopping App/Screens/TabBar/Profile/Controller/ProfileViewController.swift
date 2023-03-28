//
//  ProfileViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import UIKit
import Photos
import CoreData

class ProfileViewController: SAViewController {
    // MARK: - Properties
    let viewModel: ProfileViewModel
    let profileView = ProfileView()

    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        viewModel.delegate = self
        
        setCollectionView()
        viewModel.getUserData()
        addTapGestureToProfilePhoto()
        addLogOutButtonTarget()

        let entity = CoreDataEntities.userCoreData.rawValue
        let attribute = UserCoreDataAttributes.profilePhoto.rawValue
        viewModel.getUserImageData(entityName: entity, attributeName: attribute)
    }

    // MARK: - Methods
    func setCollectionView() {
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
        profileView.collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func setUserLabels() {
        profileView.usernameLabel.text = viewModel.user.username
        profileView.emailLabel.text = viewModel.user.email
    }

    func addTapGestureToProfilePhoto() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        profileView.profilePhoto.addGestureRecognizer(tapGesture)
    }

    @objc func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        showAlert(title: "Shopping App Would Like to Access Gallery", message: "Shopping App needs your permission to pick a profile photo from gallery.", cancelButtonTitle: "Don't Allow") { _ in
            self.present(imagePicker, animated: true)
        }
    }

    func addLogOutButtonTarget() {
        profileView.logOutButton.addTarget(nil, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }

    @objc func logOutButtonTapped() {
        showAlert(title: "Warning", message: "Are you sure you want to be log out?", cancelButtonTitle: "Cancel") { action in
            do {
                try self.auth.signOut()
                self.tabBarController?.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                self.showError(signOutError)
            }
        }
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func didAppendToFavoriteProducts() { }

    func didErrorOccured(_ error: Error) {
        showError(error)
    }

    func didFetchUserData() {
        DispatchQueue.main.async {
            self.setUserLabels()
        }
    }

    func didUploadImage(_ downloadUrl: URL) {
        viewModel.imageUrl = downloadUrl
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FavoritesCollectionViewCell else { fatalError("Cell not found") }

        cell.backgroundColor = .white
        let product = viewModel.favoriteProducts[indexPath.row]
        guard let imageUrl = product.image,
              let title = product.title,
              let price = product.price else { return cell }

        viewModel.downloadImageData(with: imageUrl) { imageData, error in
            if let error = error {
                self.showError(error)
            } else {
                guard let data = imageData,
                      let image = UIImage(data: data) else { return }
                cell.image = image
            }
        }

        cell.title = title
        cell.price = "\(price)"

        return cell
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let editedImage = info[.editedImage] as? UIImage,
              let jpegData = editedImage.jpegData(compressionQuality: 0.5),
              let compressedImage = UIImage(data: jpegData) else { return }

        viewModel.uploadProfilePhoto(with: jpegData)
        profileView.profilePhoto.image = compressedImage

        let entity = CoreDataEntities.userCoreData.rawValue
        let attribute = UserCoreDataAttributes.profilePhoto.rawValue
        viewModel.saveImageData(data: jpegData,
                                entityName: entity,
                                attributeName: attribute)


        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func didGetUserImageData(_ imageData: Data) {
        let image = UIImage(data: imageData)
        DispatchQueue.main.async {
            self.profileView.profilePhoto.image = image
        }
    }

}
