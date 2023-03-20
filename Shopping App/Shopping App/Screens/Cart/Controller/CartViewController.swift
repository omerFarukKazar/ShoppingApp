//
//  CartViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import UIKit

final class CartViewController: SAViewController {
    // MARK: - Properties
    private let viewModel: CartViewModel
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

extension CartViewController: UITableViewDelegate {

}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell
        guard let cell = cell else { fatalError("Cell not found!") }
        cell.backgroundColor = .lightGray
        return cell
    }

}
