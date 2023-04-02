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

protocol CellDelegate: AnyObject {
    func didStepperValueChanged(_ operation: CartOperation,
                                _ value: Int,
                                _ indexPath: IndexPath)
    func didTapRemoveButton(_ indexPath: IndexPath)
}

final class CartTableViewCell: UITableViewCell {
    // MARK: Properties
    var didStepperValueChanged: ((CartOperation, Int) -> Void)?
    weak var delegate: CellDelegate?
    var indexPath: IndexPath = []
    /// quantity of product in cart.
    var quantity: Int? {
        didSet {
            DispatchQueue.main.async {
                guard let quantity = self.quantity else { return }
                self.stepperLabel.text = "\(quantity)"
            }
        }
    }

    lazy var cellWidth: CGFloat = {
        self.bounds.width
    }()

    lazy var cellHeight: CGFloat = {
        self.bounds.height
    }()

    // MARK: UI Elements
    let productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.contentMode = .scaleToFill
        return productImageView
    }()

    let productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.numberOfLines = 2
        productNameLabel.font = .systemFont(ofSize: 16)
        return productNameLabel
    }()

    let productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = .systemFont(ofSize: 18)
        return productPriceLabel
    }()

    private let removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.setBackgroundImage(UIImage(named: CartIcons.trash.rawValue), for: .normal)
        removeButton.addTarget(nil, action: #selector(removeProduct), for: .touchUpInside)
        return removeButton
    }()

    let stepperLabel: UILabel = {
        let stepperLabel = UILabel()
        stepperLabel.font = .systemFont(ofSize: 16.0)
        return stepperLabel
    }()

    var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.isUserInteractionEnabled = true
        stepper.addTarget(nil, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
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

    @objc func removeProduct() {
        delegate?.didTapRemoveButton(indexPath)
    }

    @objc func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        guard let previousValue = quantity else { return }
        self.quantity = value

        if previousValue > value {
            delegate?.didStepperValueChanged(.decrease, value, indexPath)
        } else if previousValue < value {
            delegate?.didStepperValueChanged(.increase, value, indexPath)
        }
    }

    private func setProductImageViewConstraints() {
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
             productImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             productImageView.widthAnchor.constraint(equalToConstant: cellWidth * 0.3),
             productImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setRemoveButtonConstraints() {
        contentView.addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [removeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
             removeButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             removeButton.widthAnchor.constraint(equalToConstant: cellWidth * 0.1),
             removeButton.heightAnchor.constraint(equalToConstant: cellWidth * 0.1)
            ])
    }

    private func setProductNameLabelConstraints() {
        contentView.addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
             productNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
             productNameLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -16.0)
            ])
    }

    private func setProductPriceLabelConstraints() {
        contentView.addSubview(productPriceLabel)
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [productPriceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
             productPriceLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setStepperConstraints() {
        contentView.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stepper.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
             stepper.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func setStepperLabelConstraints() {
        contentView.addSubview(stepperLabel)
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stepperLabel.centerXAnchor.constraint(equalTo: stepper.centerXAnchor),
             stepperLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor)])
    }

}
