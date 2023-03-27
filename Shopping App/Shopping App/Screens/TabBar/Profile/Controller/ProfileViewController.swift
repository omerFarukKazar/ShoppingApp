//
//  ProfileViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import UIKit

class ProfileViewController: SAViewController {
    // MARK: - Properties
    let viewModel: ProfileViewModel?
    let profileView = ProfileView()

    // MARK: - Init
    init(viewModel: ProfileViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        view = profileView
    }

    func setCollectionView() {
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
        profileView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension ProfileViewController: UICollectionViewDelegate {

}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .brown
        return cell
    }

}
