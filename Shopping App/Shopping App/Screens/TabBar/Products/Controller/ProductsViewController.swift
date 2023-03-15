//
//  ProductsViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import UIKit

final class ProductsViewController: SAViewController {
    // MARK: - Properties
    var collectionView: UICollectionView!
    let viewModel: ProductsViewModel

    // MARK: - Init
    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setCollectionViewDelegateAndDataSource()
        setProductsViewModelDelegate()
        viewModel.fetchProducts()
        viewModel.fetchFavoritesFromDB()
    }

    // MARK: - Methods
    /// Instantiates and sets a UICollectionViewFlowLayout, uses it to create a CollectionView.
    /// Assigns that collectionview to self.view
    private func setCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: screenWidth / 2.2, height: 320)
            layout.scrollDirection = .vertical
            return layout
        }()

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(ProductsViewCell.self, forCellWithReuseIdentifier: "cell")

        self.view = collectionView
    }

    /// Sets collectionView's delegate and data source to self.
    private func setCollectionViewDelegateAndDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setProductsViewModelDelegate() {
        viewModel.delegate = self
    }

}

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell
        guard let cell = cell else { fatalError("ProductsViewCell can not found.") }
        guard let product = viewModel.productFor(indexPath) else {
            fatalError("Product could not found.")
        }

        // Unwrap product properties and shorten their names.
        guard let rate = product.rating?.rate,
              let count = product.rating?.count,
              let price = product.price,
              let id = product.id else { return cell }
        cell.rateLabel.text = "\(rate)"
        cell.countLabel.text = "(\(count))"
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "$ \(price)"

        // Fetch the latest favorite items from DB
        viewModel.fetchFavoritesFromDB()
        cell.isFavorite = viewModel.favorites.contains(id)

        // This can be added to UIColor as an extension. UIColor(rate: ) -> UIColor
        let rgbaValues = viewModel.setRatingViewBackgroundColor(withRespectTo: rate)
        cell.ratingStackView.backgroundColor = UIColor(red: rgbaValues[0], green: rgbaValues[1], blue: rgbaValues[2], alpha: rgbaValues[3])

        // If favorite button is triggered, this closure will work for that cell.
        cell.didTapFavoriteButton = {
            if cell.isFavorite {
                self.viewModel.removeFromFavoritesWith(id: id) {
                    cell.isFavorite.toggle()
                    // TODO:
                    // Network call causes a little delay to toggle button state.
                    // Button can be toggled before network call and due to response, it can toggled again or kept at the same state?
                }
            } else {
                self.viewModel.addToFavoritesWith(id: id) {
                    cell.isFavorite.toggle()
                }
            }
        }
        return cell
    }

}

extension ProductsViewController: ProductsViewModelDelegate {
    /// Reloads collectionView data if fetch is successful.
    func didFetchProducts() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func didErrorOccured(_ error: Error) {
        print(error.localizedDescription)
    }

    func didFetchImage() {
        print("imageFetched")
    }

    func didAddToFavorites() {
    }

    func didRemoveFromFavorites() {
    }

}
