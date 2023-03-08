//
//  AuthViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - Properties
    private let logInView = LogInView()
    private let signUpView = SignUpView()
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

        switchToLogInView()
    }

    // MARK: - Methods
    /// Changes the 'self.view' to 'logInView' and does the necessary preparations.
    private func switchToLogInView() {
        logInView.createNewAccountButton.addTarget(nil,
                                                   action: #selector(createNewAccountButtonTapped), for: .allEvents)
        self.view = logInView
    }

    /// Changes the 'self.view' to 'signUpView' and does the necessary preparations.
    private func switchToSignUpView() {
        signUpView.alreadyHaveAnAccountButton.addTarget(nil,
                                                        action: #selector(alreadyHaveAnAccountButtonTapped), for: .allEvents)
        self.view = signUpView
    }

    /// Selector method of createNewAccountButton
    @objc private func createNewAccountButtonTapped() {
        switchToSignUpView()
    }

    /// Selector method of alreadyHaveAnAccountButton.
    @objc private func alreadyHaveAnAccountButtonTapped() {
        switchToLogInView()
    }
}
