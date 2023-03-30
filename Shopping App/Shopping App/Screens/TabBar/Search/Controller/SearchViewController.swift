//
//  SearchViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import UIKit

final class SearchViewController: SAViewController {

    // MARK: - Properties
    let viewModel: SearchViewModel
    let searchView = SearchView()
    var filteredProducts: Products = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchView.collectionView.reloadData()
            }
        }
    }

    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view = searchView
        addSearchBar()
        setSearchBarDelegate()
        setCollectionViewDelegateAndDataSource()
        viewModel.fetchAllProducts()
        viewModel.fetchCategories()
    }

    // MARK: - Methods
    func addSearchBar() {
        navigationItem.searchController = searchView.searchController
    }

    func setSearchBarDelegate() {
        searchView.searchController.searchBar.delegate = self
    }
    func setCollectionViewDelegateAndDataSource() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            guard let products = viewModel.products else { return }
            let filteredProducts = products.filter({ product in

                let isTitleContains = product.title?.contains(searchText) ?? false
                let isDescriptionContains = product.description?.contains(searchText) ?? false

                return isTitleContains || isDescriptionContains
            })

            self.filteredProducts = filteredProducts
            print("Search text: \(searchText)")
        }
    }
}

extension SearchViewController: UICollectionViewDelegate { }

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell else { fatalError("Cell Not Found") }

        let product = filteredProducts[indexPath.row]
        guard let name = product.title,
              let rating = product.rating,
              let rate = rating.rate,
              let count = rating.count,
              let price = product.price,
              let imageUrl = product.image,
              let id = product.id else { fatalError("product couldn't found")}

        viewModel.fetchImageData(imageUrl) { imageData, error in
            if let error = error {
                self.showError(error)
            } else {
                guard let data = imageData else { return }
                cell.productImage = UIImage(data: data)
            }
        }

        let rgbaValues = viewModel.setRatingViewBackgroundColor(withRespectTo: rate)
        cell.ratingStackView.backgroundColor = UIColor(red: rgbaValues[0],
                                                       green: rgbaValues[1],
                                                       blue: rgbaValues[2],
                                                       alpha: rgbaValues[3])
        cell.isFavorite = ProductsManager.favorites.contains(id)
        cell.titleLabel.text = name
        cell.rateLabel.text = "\(rate)"
        cell.countLabel.text = "(\(count))"
        cell.priceLabel.text = "$ \(price)"


        return cell
    }
}
