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
        setCollectionViewDelegateAndDataSource()
        addSearchBar()
        setSearchBarDelegate()
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

extension SearchViewController: UISearchBarDelegate { }

extension SearchViewController: UICollectionViewDelegate { }

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell else { fatalError("Cell Not Found") }
        cell.backgroundColor = .cyan
        return cell
    }
}
