//
//  AuthViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 25.02.2023.
//

import UIKit

final class AuthViewController: SAViewController {

    // MARK: - Properties
    private let logInView = LogInView()
    private let signUpView = SignUpView()
    private let viewModel: AuthViewModel
    private var birthdayDate: String?

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

        viewModel.delegate = self
        switchToLogInView()

    }

    // MARK: - Methods
    // MARK: Switch View Methods
    /// Changes the 'self.view' to 'logInView' and does the necessary preparations.
    private func switchToLogInView() {
        addCreateNewAccountButtonTarget()
        addLogInButtonTarget()


#if targetEnvironment(simulator)
        logInView.emailTextView.text = "deneme@gmail.com"
        logInView.passwordTextView.text = "123456"
#endif

        self.view = logInView
        logInView.fadeOut(duration: 0.5)
        logInView.fadeIn(duration: 0.5)
    }

    /// Changes the 'self.view' to 'signUpView' and does the necessary preparations.
    private func switchToSignUpView() {
        addAlreadyHaveAnAccountButtonTarget()
        addDatePickerTarget()
        addSignUpButtonTarget()

        self.view = signUpView
        signUpView.fadeOut(duration: 0.5)
        signUpView.fadeIn(duration: 0.5)
    }

    // MARK: Button Target Methods
    // Create New Account Button Methods
    func addCreateNewAccountButtonTarget() {
        logInView.createNewAccountButton.addTarget(nil,
                                                   action: #selector(createNewAccountButtonTapped),
                                                   for: .touchUpInside)
    }

    /// Selector method of createNewAccountButton
    @objc private func createNewAccountButtonTapped() {
        switchToSignUpView()
    }

    // Already Have An Account Button Methods
    func addAlreadyHaveAnAccountButtonTarget() {
        signUpView.alreadyHaveAnAccountButton.addTarget(nil,
                                                        action: #selector(alreadyHaveAnAccountButtonTapped),
                                                        for: .touchUpInside)
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
        birthdayDate = formatter.string(from: sender.date)
    }

    // MARK: Authorization Button Methods
    // Log In Button Methods
    private func addLogInButtonTarget() {
        logInView.logInButton.addTarget(nil, action: #selector(logInButtonTapped), for: .touchUpInside)
    }

    @objc private func logInButtonTapped() {
        guard let email = logInView.emailTextView.text,
              let password = logInView.passwordTextView.text
                // email.isEmpty || password.isEmpty
                // This could be a solution
        else {
            // showAlert(title: "Error", message: "Please fill all the fields.")
            return
        }

        viewModel.logIn(email: email, password: password)
    }

    // Sign Up Button Methods
    private func addSignUpButtonTarget() {
        signUpView.signUpButton.addTarget(nil, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        guard let username = signUpView.usernameTextView.text,
              let email = signUpView.emailTextView.text,
              let password = signUpView.passwordTextView.text,
              let passwordAgain = signUpView.passwordAgainTextView.text,
              let birthday = birthdayDate
        else { return }

        if password != passwordAgain {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }

        viewModel.signUp(username: username,
                         email: email,
                         password: password,
                         birthday: birthday)
    }

}

// MARK: - AuthDelegate
extension AuthViewController: AuthDelegate {
    func isSignUpSuccessful() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }

    func isLogInSuccessful() {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }

    func didErrorOccured(_ error: Error) {
        showError(error)
    }
}
