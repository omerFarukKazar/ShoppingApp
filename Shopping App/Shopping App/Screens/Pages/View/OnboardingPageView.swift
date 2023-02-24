//
//  OnboardingPageView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 19.02.2023.
//

import UIKit

final class OnboardingPageView: UIView {

    // MARK: - Properties
    // Used these properties to keep UI Elements private.
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var headingTitle: String? {
        didSet {
            headingLabel.text = headingTitle
        }
    }

    var subheadingTitle: String? {
        didSet {
            subheadingLabel.text = subheadingTitle
        }
    }

    // MARK: - UI Elements
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let headingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 16
        return label
    }()

    private let subheadingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 16
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setConstraints() {
        let screenWidth = screenWidth // Since screenWidth is a computed property, i don't want to compute that everytime it's used. That's why i create a local stored property.
        let screenHeight = screenHeight

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            imageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.3)
        ]) // Used screenHeight and ScreenWidth in order to maintain the responsive design.

        addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            headingLabel.topAnchor.constraint(equalTo: imageView.layoutMarginsGuide.bottomAnchor,
                                              constant: screenHeight * 0.05)
        ])

        addSubview(subheadingLabel)
        subheadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subheadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subheadingLabel.widthAnchor.constraint(equalToConstant: screenWidth * 0.8),
            subheadingLabel.topAnchor.constraint(equalTo: headingLabel.layoutMarginsGuide.topAnchor,
                                                 constant: screenHeight * 0.05)
        ])

    }
}
