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

    // MARK: UI Elements
    private let productImageView: UIImageView = {
        let productImageView = UIImageView()
        return productImageView
    }()

    private let productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.numberOfLines = 2
        productNameLabel.font = .systemFont(ofSize: 16)
        return productNameLabel
    }()

    private let productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = .systemFont(ofSize: 18)
        return productPriceLabel
    }()

    private let removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.setImage(UIImage(named: CartIcons.trash
            .rawValue), for: .normal)
        return removeButton
    }()

    private let stepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    // MARK: - Methods

}
