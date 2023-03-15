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

}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell
        guard let cell = cell else { fatalError("ProductsViewCell can not found.") }
        cell.backgroundColor = .lightGray

        return cell
    }

}

extension ProductsViewController: ProductsViewDelegate {
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
        print("added to fav")
    }

    func didRemoveFromFavorites() {
        print("removed from fav")
    }

}
