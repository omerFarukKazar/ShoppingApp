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
    /// Stands for 'titleLabel.text'. Shortened the property's name.
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    /// Stands for 'textField.text'. Shortened the property's name.
    var text: String? {
        get {
            if textField.text == "" {
                shake()
                changeColor()
                return nil // I'll unwrap it before use anyways.
            } else {
                return textField.text
            }
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

    // MARK: - Methods
    /// Shake animation for the view.
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    /// Change color to red and original back.
    private func changeColor() {
        let latestColor = titleLabel.textColor // Created a variable to get latest color to be able to return it.
        // Could've write .lightGray but this is a better approach in case of
        // default color of SATextView is changed after definition.
        titleLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.titleLabel.textColor = latestColor
        }
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
