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
        logInView.fadeOut(duration: 0.5)
        logInView.fadeIn(duration: 0.5)
    }

    /// Changes the 'self.view' to 'signUpView' and does the necessary preparations.
    private func switchToSignUpView() {
        signUpView.alreadyHaveAnAccountButton.addTarget(nil,
                                                        action: #selector(alreadyHaveAnAccountButtonTapped), for: .allEvents)
        addDatePickerTarget()
        self.view = signUpView
        signUpView.fadeOut(duration: 0.5)
        signUpView.fadeIn(duration: 0.5)
    }

    /// Selector method of createNewAccountButton
    @objc private func createNewAccountButtonTapped() {
        switchToSignUpView()
    }

    /// Selector method of alreadyHaveAnAccountButton.
    @objc private func alreadyHaveAnAccountButtonTapped() {
        switchToLogInView()
    }

    // MARK: Date Picker Methods
    private func addDatePickerTarget() {
        signUpView.birthdayPicker.addTarget(nil,
                                            action: #selector(didDatePickerValueChanged(_:)),
                                            for: .valueChanged)
    }

    @objc private func didDatePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        let date = formatter.string(from: sender.date)
        print(date)
    }

}
