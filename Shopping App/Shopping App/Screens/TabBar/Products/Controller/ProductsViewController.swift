//
//  ProductsViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import UIKit

final class ProductsViewController: SAViewController {
    func didOperationSuccess() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Properties
    var collectionView: UICollectionView!
    let viewModel: ProductsViewModel
    var isCartEmpty: Bool = true {
        didSet {
            // swiftlint:disable:next line_length
            let image = isCartEmpty ? UIImage(named: ProductViewAssets.cart.rawValue) : UIImage(named: ProductViewAssets.cartCheckout.rawValue)
            navigationBarCartButton(with: image)
        }
    }
    var selectedCellIndexPath: IndexPath?

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
        tabBarController?.navigationController?.navigationBar.isHidden = true
        title = "Products"
        updateIsCartEmptyProperty()
        setCollectionView()
        setCollectionViewDelegateAndDataSource()
        setProductsViewModelDelegate()
        viewModel.fetchFavoritesFromDB()
        viewModel.fetchProducts()
        viewModel.delegate = self
    }

    // Used to reload cell in case of some changes in ProductDetailView made.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
        updateIsCartEmptyProperty()

        guard let indexPath = selectedCellIndexPath else { return }
        collectionView.reloadItems(at: [indexPath])
    }

    // MARK: - Methods
    // MARK: CartButton
    /// Sets navigation cart button with the given image.
    private func navigationBarCartButton(with image: UIImage?) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped))
    }

    /// set and push CartViewController()
    @objc private func cartButtonTapped() {
        let viewModel = CartViewModel(service: ProductsService())
        let viewController = CartViewController(viewModel: viewModel)

        // I prefer passing products instead of sending request and downloading them again.
        // Decrease server traffic.
        // Filter for products already added to Cart and pass them to Cart Screen
        viewModel.productsInCart = productsInCart()!

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func updateIsCartEmptyProperty() {
        isCartEmpty = ProductsManager.cart.isEmpty
    }

    // MARK: 'sets'
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

    private func setCollectionViewDelegateAndDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setProductsViewModelDelegate() {
        viewModel.delegate = self
    }

    /**
     Filters product by their id's and if condition is matched, appends that to return value.

     - returns: Products?
     */
    private func productsInCart() -> Products? {
        let cartDictionaryKeys = Array(ProductsManager.cart.keys) // transform keys into array
        let cartIdArray = cartDictionaryKeys.sorted() // sort them
        let filteredProducts = self.viewModel.products.filter {
            cartIdArray.contains($0.id!) // If array contains that product, add it.
        }
        return filteredProducts
    }

}
// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Instantiate View Controller
        guard let product = viewModel.productFor(indexPath) else { return }
        var viewModel = ProductDetailViewModel(product: product, service: ProductsService())
        viewModel.productsInCart = productsInCart()
//        ProductsManager.productsInCart = productsInCart() ?? []

        let viewController = ProductDetailViewController(viewModel: viewModel)

        // Pass the data to selected cell and pushVC.
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductsViewCell {
            viewController.isFavorite = cell.isFavorite
            viewController.productDetailView.image = cell.productImage
            viewController.productId = product.id

            self.selectedCellIndexPath = indexPath
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showAlert(title: "Error", message: "Product not found!")
        }
    }

}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Instantiate cell and product
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductsViewCell
        guard let cell = cell else { fatalError("ProductsViewCell can not found.") }
        guard let product = viewModel.productFor(indexPath) else {
            fatalError("Product not found.")
        }

        // Unwrap product properties and shorten their names.
        guard let rate = product.rating?.rate,
              let count = product.rating?.count,
              let price = product.price,
              let id = product.id,
              let imageUrl = product.image else { return cell }
        cell.rateLabel.text = "\(rate)"
        cell.countLabel.text = "(\(count))"
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "$ \(price)"

        // Download image with product's url
        viewModel.downloadImageWith(imageUrl) { imageData, error in
            if let error = error {
                self.didErrorOccured(error)
            }
            guard let data = imageData else { return }
            cell.productImage = UIImage(data: data)
        }

        // Check if cell is favorited.
        cell.isFavorite = ProductsManager.favorites.contains(id)

        // This can be added to UIColor as an extension to avoid code repetition. UIColor(rate: ) -> UIColor
        let rgbaValues = viewModel.setRatingViewBackgroundColor(withRespectTo: rate)
        cell.ratingStackView.backgroundColor = UIColor(red: rgbaValues[0],
                                                       green: rgbaValues[1],
                                                       blue: rgbaValues[2],
                                                       alpha: rgbaValues[3])

        // When favorite button is tapped, this closure will work for that cell.
        // Adds or removes product according to the state of cell's isFavorite property.
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
        return cell
    }

}

// MARK: - ProductsViewModelDelegate
extension ProductsViewController: ProductsViewModelDelegate {
    /// Reloads collectionView data when triggered..
    func didFetchProducts() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    /// Presents an alert when triggered.
    func didErrorOccured(_ error: Error) {
        self.showAlert(title: "Error", message: error.localizedDescription)
    }
}
