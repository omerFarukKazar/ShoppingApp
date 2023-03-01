//
//  AuthView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 1.03.2023.
//

import UIKit

final class AuthView: UIView {
    // MARK: - Properties
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: AuthViewModel.AuthOption.logIn.title, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: AuthViewModel.AuthOption.signUp.title, at: 1, animated: true)
        return segmentedControl
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthViewModel.Placeholders.username.rawValue
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthViewModel.Placeholders.email.rawValue
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthViewModel.Placeholders.password.rawValue
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordAgainTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthViewModel.Placeholders.passwordAgain.rawValue
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let authorizationButton: UIButton = {
        let button = UIButton()
        button.setTitle(AuthViewModel.ButtonTitles.logInButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        return button
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(AuthViewModel.ButtonTitles.forgotPasswordButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [emailTextField,
         passwordTextField,
         authorizationButton,
         forgotPasswordButton].forEach { stackView.addArrangedSubview($0) }
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSegmentedControlConstraints()
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set Constraints
    private func setSegmentedControlConstraints() {
        self.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        ])
    }

    private func setStackViewConstraints() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }

}
