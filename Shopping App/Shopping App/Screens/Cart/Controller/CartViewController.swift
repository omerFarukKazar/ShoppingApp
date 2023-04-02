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

extension CartViewController: UITableViewDelegate { }

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell else { fatalError("Cell not found!") }

        cell.delegate = self
        let product = viewModel.productsInCart[indexPath.row]
        guard let imageUrl = product.image else { return cell }

        // Download and assign product image
        // TODO: Product images could be cached.
        viewModel.downloadImageWith(imageUrl) { data, error in
            if let error = error {
                self.showError(error)
            }
            guard let data = data else { return }
            let productImage = UIImage(data: data)
            DispatchQueue.main.async {
                cell.productImageView.image = productImage
            }
        }

        // pass related product's data
        guard let id = product.id,
              let quantity = ProductsManager.cart[id],
              let price = product.price,
              let title = product.title else { return cell}
        DispatchQueue.main.async {
            cell.quantity = quantity
            cell.stepper.value = Double(quantity)
            cell.productPriceLabel.text = "\(price * Double(quantity))"
            cell.productNameLabel.text = "\(title)"
            cell.indexPath = indexPath
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

    func didFetchProducts() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CartViewController: CellDelegate {
    func didStepperValueChanged(_ operation: CartOperation, _ value: Int, _ indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? CartTableViewCell else { return }

        // cell's product
        let product = viewModel.productsInCart[indexPath.row]
        guard let id = product.id else { return }

        self.viewModel.updateCart(with: operation, productId: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showError(error)
                return
            } else {
                if value == 0 {
                    self.viewModel.productsInCart.remove(at: indexPath.row)
                    self.tableView.reloadData()
                } else {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func didTapRemoveButton(_ indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? CartTableViewCell else { return }
        let product = viewModel.productsInCart[indexPath.row]
        guard let id = product.id else { return }

        viewModel.updateCart(with: .remove, productId: id) { [weak self] error in
            guard let self else { return }
            if let error = error {
                self.showError(error)
            } else {
                self.viewModel.productsInCart.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }

}
