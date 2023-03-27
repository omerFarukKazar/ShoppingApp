//
//  FavoritesCollectionViewCell.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 27.03.2023.
//

import UIKit

final class FavoritesCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.productImage.image = self.image
            }
        }
    }

    var title: String? {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = self.title
            }
        }
    }

    var price: String? {
        didSet {
            DispatchQueue.main.async {
                self.priceLabel.text = self.price
            }
        }
    }

    // MARK: - UI Elements
    private let productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.contentMode = .scaleToFill
        productImage.clipsToBounds = true
        return productImage
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 12.0)
        return nameLabel
    }()

    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textAlignment = .right
        priceLabel.font = .systemFont(ofSize: 12.0)
        return priceLabel
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProductImageConstraints()
        setNameLabelConstraints()
        setPriceLabelConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setProductImageConstraints() {
        contentView.addSubview(productImage)
        productImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productImage.topAnchor.constraint(equalTo: self.topAnchor),
            productImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)])
    }

    private func setNameLabelConstraints() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.frame.width * 0.4)])
    }

    private func setPriceLabelConstraints() {
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: self.frame.width * 0.4)])
    }
}
