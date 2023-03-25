//
//  ProductDetailViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import UIKit

final class ProductDetailViewController: SAViewController {

    // MARK: - Properties
    var viewModel: ProductDetailViewModel
    let productDetailView = ProductDetailView()
    var isFavorite = false {
        didSet {
            if isFavorite {
                productDetailView.favoriteButton.setBackgroundImage(
                    UIImage(named: ProductsViewCellIcons.heartFill.rawValue),
                    for: .normal)
            } else {
                productDetailView.favoriteButton.setBackgroundImage(
                    UIImage(named: ProductsViewCellIcons.heart.rawValue),
                    for: .normal)
            }
        }
    }
    var isCartEmpty = true {
        didSet {
            let image = isCartEmpty ? UIImage(named: ProductViewAssets.cart.rawValue) : UIImage(named: ProductViewAssets.cartCheckout.rawValue)
            navigationBarCartButton(with: image)
        }
    }
    var productId: Int?

    // MARK: - Init
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view = productDetailView
        tabBarController?.tabBar.isHidden = true
        updateIsCartEmptyProperty()
        setViewData()
        addFavoriteButtonTarget()
        addCartButtonTarget()
    }

    // MARK: - Methods
    /// Unwraps product properties form viewModel and assigns them to productView.
    private func setViewData() {
        guard let title = viewModel.product.title,
              let rate = viewModel.product.rating?.rate,
              let count = viewModel.product.rating?.count,
              let price = viewModel.product.price,
              let description = viewModel.product.description else { return }

        productDetailView.rate = "\(rate)"
        productDetailView.count = "(\(count))"
        productDetailView.priceLabel.text = "$ \(price)"
        productDetailView.titleLabel.text = "Name: \(title)"
        productDetailView.descriptionLabel.text = "Description: \(description)"

    }

    // MARK: NavigationBarCartButton
    /// Sets navigation cart button with the given image.
    private func navigationBarCartButton(with image: UIImage?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped))
    }

    private func updateIsCartEmptyProperty() {
        isCartEmpty = ProductsManager.cart.isEmpty
    }

    /// set and push CartViewController
    @objc private func cartButtonTapped() {
        let viewModel = CartViewModel(service: ProductsService())
        let viewController = CartViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: FavoriteButtonFunctionality
    private func addFavoriteButtonTarget() {
        productDetailView.favoriteButton.addTarget(nil,
                                             action: #selector(favoriteButtonTapped),
                                             for: .touchUpInside)
    }

    /// Checks the isFavorite property and oggles the favorite state of product.
    /// Updates database
    /// Updates static 'favorites' property.
    @objc private func favoriteButtonTapped() {
        if isFavorite {
            viewModel.removeFromFavorites(with: productId) { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.isFavorite.toggle()

                }
            }
        } else {
            viewModel.addToFavorites(with: productId) { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.isFavorite.toggle()
                }
            }
        }
    }

    // MARK: AddToCartButtonFunctionality
    private func addCartButtonTarget() {
        productDetailView.addToCartButton.addTarget(nil,
                                              action: #selector(addToCartButtonTapped),
                                              for: .touchUpInside)

    }

    /// Adds product to "cart" in FireStore
    /// Updates singleton cart property.
    @objc private func addToCartButtonTapped() {
        viewModel.updateCart(with: .increase, productId: productId) { error in
            if let error = error {
                self.showAlert(title: "Error",
                               message: error.localizedDescription)
                return
            } else {
                self.productDetailView.addToCartButton.backgroundColor = UIColor(hex: "539165")

                self.updateIsCartEmptyProperty()
                self.showAlert(title: "Product added to Cart")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: true)
                    self.productDetailView.addToCartButton.backgroundColor = .blue
                }
            }
        }
    }
}
