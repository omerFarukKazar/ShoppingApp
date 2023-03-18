//
//  ProductDetailView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import UIKit

enum ProductViewAssets: String {
    case cart = "cart"
    case cartCheckout = "cart.checkout"
}

final class ProductDetailView: UIView {
    // MARK: - Properties
    var didTapFavoriteButton: (() -> Void)?
    // TODO: Another scaling for fonts maybe?
    lazy var scaledScreenWidth: CGFloat = {
        screenWidth * 0.5
    }()
    lazy var scaledScreenHeight: CGFloat = {
        screenHeight * 0.4
    }()
    // MARK: - UI Elements
    // TODO: I can't decide if creating new computed properties is better than
    // setting UI elements to internal.
    var image: UIImage? {
        get {
            productImageView.image
        }
        set {
            productImageView.image = newValue
        }
    }

    var rate: String? {
        get {
            rateLabel.text
        }
        set {
            rateLabel.text = newValue
        }
    }

    var count: String? {
        get {
            countLabel.text
        }
        set {
            countLabel.text = newValue
        }
    }

    // MARK: ProductImageView
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        return favoriteButton
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let lineView: UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.lightGray.cgColor
        return lineView
    }()

    // MARK: RatingView
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ProductsViewCellIcons.starFill.rawValue)
        return imageView
    }()

    private let rateLabel: UILabel = {
        let rateLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 18.0)
        rateLabel.font = font
        return rateLabel
    }()

    private let countLabel: UILabel = {
        let countLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 16.0)
        countLabel.font = font
        return countLabel
    }()

    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.autoresizesSubviews = true
        stackView.layer.cornerRadius = 5
        [starImageView,
         rateLabel,
         countLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        let font = UIFont.systemFont(ofSize: 18.0)
        priceLabel.font = font
        return priceLabel
    }()

    // MARK: titleStackView
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        let font = UIFont.systemFont(ofSize: 20.0)
        titleLabel.font = font
        return titleLabel
    }()

    let descriptionLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        let font = UIFont.systemFont(ofSize: 16.0)
        titleLabel.font = font
        return titleLabel
    }()

    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        [titleLabel,
         descriptionLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    let addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Add To Cart", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setProductImageViewConstraints()
        setFavoriteButtonConstraints()
        setRatingStackViewConstraints()
        setPriceLabelConstraints()
        setLineViewConstraints()
        setTitleStackViewConstraints()
        setAddToCartButtonConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setProductImageViewConstraints() {
        addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: screenWidth * 0.15),
            productImageView.heightAnchor.constraint(equalToConstant: scaledScreenHeight * 0.55)
        ])
    }

    private func setFavoriteButtonConstraints() {
        self.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 8.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: scaledScreenWidth * 0.15),
            favoriteButton.heightAnchor.constraint(equalToConstant: scaledScreenWidth * 0.15)])
    }

    private func setRatingStackViewConstraints() {
        productImageView.addSubview(ratingStackView)
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingStackView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            ratingStackView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: scaledScreenHeight * 0.06)
                                ])
    }

    private func setPriceLabelConstraints() {
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: productImageView.layoutMarginsGuide.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setLineViewConstraints() {
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            lineView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16.0),
            lineView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1.0)])
    }

    private func setTitleStackViewConstraints() {
        addSubview(titleStackView)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            titleStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16.0),
            titleStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)])
    }

    private func setAddToCartButtonConstraints() {
        addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCartButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: screenWidth * 0.1),
            addToCartButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -(screenWidth * 0.1)),
            addToCartButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -(screenWidth * 0.025))])
    }

}
