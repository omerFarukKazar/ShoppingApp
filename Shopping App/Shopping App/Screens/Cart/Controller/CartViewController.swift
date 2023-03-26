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
        ProductsManager.cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell
        guard let cell = cell else { fatalError("Cell not found!") }
        
        guard let product = products?[indexPath.row],
              let imageUrl = product.image else { return cell }
        
        // Download and assign product image
        var productImage: UIImage?
        viewModel.downloadImageWith(imageUrl) { data, error in
            if let error = error {
                self.showError(error)
            }
            guard let data = data else { return }
            productImage = UIImage(data: data)
        }
        
        guard let id = product.id,
              let quantity = ProductsManager.cart[id],
              let price = product.price,
              let title = product.title else { return cell}
        DispatchQueue.main.async {
            cell.quantity = quantity
            cell.stepper.value = Double(quantity)
            cell.productPriceLabel.text = "\(price * Double(quantity))"
            cell.productNameLabel.text = "\(title)"
            cell.productImageView.image = productImage
        }
        
        
        cell.didStepperValueChanged = { operation, value in
            self.viewModel.updateCart(with: operation, productId: id) { error in
                if let error = error {
                    self.showError(error)
                    return
                } else {
                    if value == 0 {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            cell.quantity = value
                        }
                    }
                }
            }
            print(ProductsManager.cart)
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
