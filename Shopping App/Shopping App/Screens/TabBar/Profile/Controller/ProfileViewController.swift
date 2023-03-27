//
//  ProfileViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import UIKit

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
    }

    // MARK: - Methods
    func setCollectionView() {
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
        profileView.collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FavoritesCollectionViewCell else { fatalError("Cell not found") }

        cell.backgroundColor = .brown
        return cell
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    func didAppendToFavoriteProducts() { }

    func didErrorOccured(_ error: Error) {
        showError(error)
    }

    func didFetchImageData(_ data: Data) {
        
    }
}
