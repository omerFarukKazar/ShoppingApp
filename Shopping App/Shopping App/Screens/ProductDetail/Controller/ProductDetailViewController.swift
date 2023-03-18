//
//  ProductDetailViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import UIKit

final class ProductDetailViewController: SAViewController {

    // MARK: - Properties
    let viewModel: ProductDetailViewModel
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
        addFavoriteButtonTarget()
    }

    // MARK: FavoriteButtonFunctionality
    private func addFavoriteButtonTarget() {
        productDetailView.favoriteButton.addTarget(nil,
                                             action: #selector(favoriteButtonTapped),
                                             for: .touchUpInside)
    }
    @objc private func favoriteButtonTapped() {
    }
