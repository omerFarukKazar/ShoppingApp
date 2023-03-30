//
//  SearchView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 29.03.2023.
//

import UIKit

final class SearchView: UIView {
    // MARK: - UI Elements
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search"
        return sc
    }()


    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let cvfl = UICollectionViewFlowLayout()
        cvfl.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cvfl.itemSize = CGSize(width: screenWidth / 2.2, height: 320)
        cvfl.scrollDirection = .vertical
        return cvfl
    }

    var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .brown
        return cv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
        setCollectionViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(ProductsViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func setCollectionViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
