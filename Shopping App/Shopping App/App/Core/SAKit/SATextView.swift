//
//  SATextField.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.03.2023.
//

import UIKit

/// Custom view which includes a UITextField and a UILabel above the textfield.
class SATextView: UIView {

    // MARK: - Properties
    /// Stands for 'titlelabel.text'. Shortened the property's name.
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    /// Stands for 'textField.text'. Shortened the property's name.
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabelConstraints()
        setTextFieldConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    func setLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
    ])
    }

    func setTextFieldConstraints() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }

}
