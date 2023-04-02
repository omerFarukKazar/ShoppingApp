//
//  ProfileView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import UIKit

final class ProfileView: UIView {

    // MARK: UI Elements
    lazy var profilePhoto: UIImageView = {
        let profilePhoto = UIImageView()
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = screenWidth * 0.5 / 2
        profilePhoto.image = UIImage(named: "imagePlaceholder")
        return profilePhoto
    }()

    let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        usernameLabel.textAlignment = .center
        usernameLabel.numberOfLines = 3
        return usernameLabel
    }()

    let emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 3
        return emailLabel
    }()

    let favoritesLabel: UILabel = {
        let favoritesLabel = UILabel()
        favoritesLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        favoritesLabel.text = "Favorites"
        return favoritesLabel
    }()

    // CollectionView
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenHeight * 0.18)
        layout.scrollDirection = .horizontal
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()

    let logOutButton: UIButton = {
        let logOutButton = UIButton()
        logOutButton.setTitleColor(.blue, for: .normal)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.cornerRadius = 15.0
        return logOutButton
    }()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setProfilePhotoConstraints()
        setUsernameLabelConstraints()
        setEmailLabelConstraints()
        setFavoritesLabelConstraints()
        setLogOutButton()
        setCollectionViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    private func setProfilePhotoConstraints() {
        addSubview(profilePhoto)
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhoto.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePhoto.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: screenHeight * 0.025),
            profilePhoto.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            profilePhoto.heightAnchor.constraint(equalToConstant: screenWidth * 0.5)])
    }

    private func setUsernameLabelConstraints() {
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 16.0),
            usernameLabel.heightAnchor.constraint(equalToConstant: screenWidth * 0.18),
            usernameLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.8)])
    }

    private func setEmailLabelConstraints() {
        addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8.0),
            emailLabel.heightAnchor.constraint(equalToConstant: screenWidth * 0.18),
            emailLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.8)])
    }

    private func setFavoritesLabelConstraints() {
        addSubview(favoritesLabel)
        favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            favoritesLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8.0),
            favoritesLabel.heightAnchor.constraint(equalToConstant: 32.0)])
    }

    private func setLogOutButton() {
        addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -16.0),
            logOutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            logOutButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.075)])
    }

    private func setCollectionViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: logOutButton.topAnchor, constant: -48.0)
        ])
    }
}
