//
//  SATextField.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 2.03.2023.
//

import UIKit

/// A textfield with secure entry option which can be toggled by the eye icon at the trailing edge.
final class SATextViewWithSecureEntry: SATextView {

    // MARK: - Enum
    /// Icon Names in order to avoid typo.
    private enum IconNames: String {
        case openEye
        case closedEye
    }

    // MARK: - UI Elements
    /// The eye shaped button with the ability to toggle secure entry for touch up inside.
    private let toggleSecureEntryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: IconNames.openEye.rawValue), for: .normal)
        button.addTarget(nil, action: #selector(toggleSecureEntry), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.isSecureTextEntry = false
        addSecureEntry()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    /// Toggles secure entry mode and changes the button icon with respect to isSecureTextEntry state.
    @objc private func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()

        switch textField.isSecureTextEntry {
        case true:
            toggleSecureEntryButton.setImage(UIImage(named: IconNames.closedEye.rawValue), for: .normal)
        case false:
            toggleSecureEntryButton.setImage(UIImage(named: IconNames.openEye.rawValue), for: .normal)
        }

    }

    // MARK: - Constraints
    func addSecureEntry() {
        textField.rightView = toggleSecureEntryButton
        textField.rightViewMode = .always
        self.addSubview(toggleSecureEntryButton)
    }
}
