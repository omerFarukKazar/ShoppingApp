//
//  AuthViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: AuthViewModel

    // MARK: - Init
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
