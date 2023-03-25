//
//  CartViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import UIKit

final class CartViewController: SAViewController {

    // MARK: - Properties
    private var viewModel: CartViewModel
    private var tableView: UITableView!
    var products: Products?

    // MARK: - Init
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented.")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cart"

        viewModel.delegate = self
        viewModel.fetchCart()
        prepareTableView()
//        print(products)
    }

    // MARK: - Method
    private func prepareTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = screenHeight * 0.15
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }

}

extension CartViewController: UITableViewDelegate {

}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProductsManager.cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell
        guard let cell = cell else { fatalError("Cell not found!") }
        let keys = Array(ProductsManager.cart.keys)
        let idArray = keys.sorted()

        guard let products = products,
              let imageUrl = products[indexPath.row].image else { return cell }
        let product = products[indexPath.row]
        var productImage: UIImage?

        viewModel.downloadImageWith(imageUrl) { data, error in
            if let error = error {
                self.showError(error)
            }
            guard let data = data else { return }
            productImage = UIImage(data: data)
        }

        DispatchQueue.main.async {
            cell.productPriceLabel.text = "\(product.price ?? .zero)"
            cell.productImageView.image = productImage
            cell.productNameLabel.text = "\(product.title ?? "-")"
            cell.stepperLabel.text = "\(ProductsManager.cart[indexPath.row] ?? .zero)"
        }

                viewModel.getSingleProduct(with: idArray[indexPath.row]) { product, error in
                    if let error = error {
                        self.showError(error)
                    } else {
                        guard let product = product else { return }
        
                        DispatchQueue.main.async {
                            cell.productNameLabel.text = product.title
                            cell.stepperLabel.text = "\(ProductsManager.cart[product.id ?? 0] ?? 0)"
                            cell.productPriceLabel.text = "\(product.price ?? 0)"
                        }
                    }
                }

        cell.backgroundColor = .lightGray
        return cell
    }

}

extension CartViewController: CartViewModelDelegate {
    func didErrorOccurred(_ error: Error) {
        showError(error)
    }

    func didFetchCart() {
        print("fetch")
    }
}
