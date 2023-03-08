//
//  LogInView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 1.03.2023.
//

import UIKit

final class LogInView: UIView {
    // MARK: - Properties
    private let emailTextView: SATextView = {
        let textView = SATextView()
        textView.title = AuthViewModel.Placeholders.email.rawValue
        return textView
    }()

    private let passwordTextView: SATextViewWithSecureEntry = {
        let textView = SATextViewWithSecureEntry()
        textView.title = AuthViewModel.Placeholders.password.rawValue
        return textView
    }()

    private let logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        button.setTitle(AuthViewModel.ButtonTitles.logInButton.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
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

    let createNewAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(AuthViewModel.ButtonTitles.dontYouHaveAnAccountButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [emailTextView,
         passwordTextView,
         logInButton,
         forgotPasswordButton].forEach { stackView.addArrangedSubview($0) }
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setStackViewConstraints()
        setCreateNewAccountButtonConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set Constraints
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

    private func setCreateNewAccountButtonConstraints() {
        self.addSubview(createNewAccountButton)
        createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [createNewAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             createNewAccountButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)])
    }

}
