//
//  ProductsViewCell.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 12.03.2023.
//

import UIKit

enum ProductsViewCellIcons: String {
    case heart = "heart"
    case heartFill = "heart.fill"
    case starFill = "star.fill"
}

final class ProductsViewCell: UICollectionViewCell {
    var isFavorite: Bool = false
    // MARK: - Properties

    lazy var cellWidth: CGFloat = {
        self.bounds.width
    }()

    lazy var cellHeight: CGFloat = {
        self.bounds.height
    }()

    var productImage: UIImage? {
        didSet {
            productImageView.image = productImage
        }
    }

    // MARK: - UI Elements
    // MARK: ProducImageView
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: ProductsViewCellIcons.heart.rawValue), for: .normal)
        return favoriteButton
    }()

    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "imagePlaceholder")
        return imageView
    }()

    // MARK: RatingView
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ProductsViewCellIcons.starFill.rawValue)
        return imageView
    }()

    let rateLabel: UILabel = {
        let rateLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 14.0)
        rateLabel.font = font
        rateLabel.text = "3.4"
        return rateLabel
    }()

    let countLabel: UILabel = {
        let countLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 12.0)
        countLabel.font = font
        countLabel.text = "(30)"
        return countLabel
    }()

    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.autoresizesSubviews = true
        [starImageView,
         rateLabel,
         countLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    // MARK: Title Stack View
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        let font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.font = font
        titleLabel.text = "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops"
        return titleLabel
    }()

    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 16.0)
        priceLabel.font = font
        priceLabel.text = "$ 109.95"
        return priceLabel
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        [titleLabel,
         priceLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProductImageViewConstraints()
        setRatingStackViewConstraints()
        setTitleStackViewConstraints()
        setFavoriteButtonConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setProductImageViewConstraints() {
        addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     productImageView.topAnchor.constraint(equalTo: self.topAnchor),
                                     productImageView.heightAnchor.constraint(equalToConstant: cellHeight * 0.65)
                                    ])
    }

    private func setFavoriteButtonConstraints() {
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([favoriteButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     favoriteButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     favoriteButton.widthAnchor.constraint(equalToConstant: cellWidth * 0.15),
                                     favoriteButton.heightAnchor.constraint(equalToConstant: cellWidth * 0.15)])
    }

    private func setRatingStackViewConstraints() {
        productImageView.addSubview(ratingStackView)
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ratingStackView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
                                     ratingStackView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
                                     ratingStackView.heightAnchor.constraint(equalToConstant: cellHeight * 0.06)
                                    ])
    }

    private func setTitleStackViewConstraints() {
        addSubview(titleStackView)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            titleStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8.0),
            titleStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
    }

}
