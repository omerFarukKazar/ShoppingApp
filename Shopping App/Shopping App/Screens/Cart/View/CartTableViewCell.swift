//
//  CartView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 17.03.2023.
//

import UIKit

enum CartIcons: String {
    case trash
}

final class CartTableViewCell: UITableViewCell {
    // MARK: Properties
    lazy var cellWidth: CGFloat = {
        self.bounds.width
    }()

    lazy var cellHeight: CGFloat = {
        self.bounds.height
    }()

    // MARK: UI Elements
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.image = UIImage(named: "imagePlaceholder")
        productImageView.contentMode = .scaleToFill
        return productImageView
    }()

    private let productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.numberOfLines = 2
        productNameLabel.font = .systemFont(ofSize: 16)
        productNameLabel.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
        labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation
        """
        return productNameLabel
    }()

    private let productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = .systemFont(ofSize: 18)
        productPriceLabel.text = "$ 400"
        return productPriceLabel
    }()

    private let removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.setBackgroundImage(UIImage(named: CartIcons.trash.rawValue), for: .normal)
        return removeButton
    }()

    private let stepperLabel: UILabel = {
        let stepperLabel = UILabel()
        stepperLabel.text = "1"
        stepperLabel.font = .systemFont(ofSize: 16.0)
        return stepperLabel
    }()
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setProductImageViewConstraints()
        setRemoveButtonConstraints()
        setProductNameLabelConstraints()
        setProductPriceLabelConstraints()
        setStepperConstraints()
        setStepperLabelConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setProductImageViewConstraints() {
        addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
             productImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             productImageView.widthAnchor.constraint(equalToConstant: cellWidth * 0.3),
             productImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setRemoveButtonConstraints() {
        addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [removeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
             removeButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             removeButton.widthAnchor.constraint(equalToConstant: cellWidth * 0.1),
             removeButton.heightAnchor.constraint(equalToConstant: cellWidth * 0.1)
            ])
    }

    private func setProductNameLabelConstraints() {
        addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
             productNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             productNameLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -16.0)
            ])
    }

    private func setProductPriceLabelConstraints() {
        addSubview(productPriceLabel)
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productPriceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
             productPriceLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setStepperConstraints() {
        addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stepper.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
             stepper.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setStepperLabelConstraints() {
        addSubview(stepperLabel)
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stepperLabel.centerXAnchor.constraint(equalTo: stepper.centerXAnchor),
             stepperLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor)])
    }

}
