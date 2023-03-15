//
//  SignUpView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 7.03.2023.
//

import UIKit

final class SignUpView: UIView {

    // MARK: - Properties
    let usernameTextView: SATextView = {
        let textView = SATextView()
        textView.title = AuthTextViewTitles.username.rawValue
        return textView
    }()

    let emailTextView: SATextView = {
        let textView = SATextView()
        textView.title = AuthTextViewTitles.email.rawValue
        return textView
    }()

    let passwordTextView: SATextViewWithSecureEntry = {
        let textView = SATextViewWithSecureEntry()
        textView.title = AuthTextViewTitles.password.rawValue
        return textView
    }()

    let passwordAgainTextView: SATextViewWithSecureEntry = {
        let textView = SATextViewWithSecureEntry()
        textView.title = AuthTextViewTitles.passwordAgain.rawValue
        return textView
    }()

    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = AuthTextViewTitles.birthday.rawValue
        return label
    }()

    let birthdayPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private lazy var birthdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [birthdayLabel,
         birthdayPicker].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(AuthButtonTitles.signUpButton.rawValue, for: .normal)
        button.backgroundColor = .init(red: 0.0, green: 0.5, blue: 0.3, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        return button
    }()

    let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(AuthButtonTitles.alreadyHaveAnAccountButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [usernameTextView,
         emailTextView,
         passwordTextView,
         passwordAgainTextView,
         birthdayStackView,
         signUpButton].forEach { stackView.addArrangedSubview($0) }
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setStackViewConstraints()
        setAlreadyHaveAnAccountButtonConstraints()
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

    private func setAlreadyHaveAnAccountButtonConstraints() {
        self.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             alreadyHaveAnAccountButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)])
    }

}
