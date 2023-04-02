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
    var isSearching: Bool = false

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

        viewModel.delegate = self
        viewModel.fetchAllProducts()
        viewModel.fetchCategories()

        addSegmentedControlTarget()

        addSearchBar()
        setSearchBarDelegate()

        setCollectionViewDelegateAndDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Methods

    func setSegmentedControlSegments() {
        let categories = viewModel.category
        categories.forEach({ category in
            guard let index = categories.firstIndex(of: category) else { return }
            searchView.segmentedControl.insertSegment(withTitle: category, at: index, animated: false)
        })
    }

    func addSegmentedControl() {
        navigationItem.titleView = searchView.segmentedControl
    }

    func addSegmentedControlTarget() {
        searchView.segmentedControl.addTarget(self,
                                              action: #selector(segmentedControlValueChanged(_:)),
                                              for: .valueChanged)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        guard let category = sender.titleForSegment(at: selectedSegment) else { return }
        viewModel.fetchProductsBy(category: category)
    }

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

        guard let products = viewModel.products else { return }

        if searchText.count >= 3 {

            let filteredProducts = products.filter({ product in

                let isTitleContains = product.title?.contains(searchText) ?? false
                let isDescriptionContains = product.description?.contains(searchText) ?? false

                return isTitleContains || isDescriptionContains
            })

            viewModel.searchFilteredProducts = filteredProducts
            isSearching = true
        } else {
            isSearching = false
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = isSearching ? viewModel.searchFilteredProducts[indexPath.row] : viewModel.categorizedProducts[indexPath.row]

        let service = ProductsService()
        let viewModel = ProductDetailViewModel(product: product, service: service)
        let viewController = ProductDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
        

    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isSearching ? viewModel.searchFilteredProducts.count : viewModel.categorizedProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell else { fatalError("Cell Not Found") }

        var product: Product?

        product = isSearching ? viewModel.searchFilteredProducts[indexPath.row] : viewModel.categorizedProducts[indexPath.row]
        isSearching = false
        
        guard let product = product,
              let name = product.title,
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

        cell.didTapFavoriteButton = { [weak self] in
            guard let self else { return }
            if cell.isFavorite {
                self.viewModel.removeFromFavorites(with: id) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    } else {
                        cell.isFavorite.toggle()
                    }
                }
            } else {
                self.viewModel.addToFavorites(with: id) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    } else {
                        cell.isFavorite.toggle()
                    }
                }
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

extension SearchViewController: SearchViewModelDelegate {
    func isFilteringProducts() {
        DispatchQueue.main.async {
            self.searchView.collectionView.reloadData()
        }
    }

    func didFetchCategories() {
        DispatchQueue.main.async {
            self.setSegmentedControlSegments()
            self.addSegmentedControl()
        }
    }

    func didErrorOccured(_ error: Error) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }
}
