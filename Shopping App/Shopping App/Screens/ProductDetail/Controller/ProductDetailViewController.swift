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
    }
