//
//  ProfileViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.03.2023.
//

import UIKit

class ProfileViewController: SAViewController {
    // MARK: - Properties
    let viewModel: ProfileViewModel?
    let profileView = ProfileView()

    // MARK: - Init
    init(viewModel: ProfileViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
    }

}
