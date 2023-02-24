//
//  OnboardingView.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.02.2023.
//

import UIKit

final class OnboardingView: UIView {

    /// This enum contains Button titles for OnboardingView.
    enum ButtonTitles: String, RawRepresentable {
        case backButton = "Back"
        case nextButton = "Next"
        case skipButton = "Skip"
        case doneButton = "Done"
    }
    // MARK: - Properties
    var pagesView = OnboardingPageView()

    // Initialized properties below by using Initialization with closures because made some additional changes on the UI elements.
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitles.backButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

     let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitles.nextButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitles.skipButton.rawValue, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .blue
        return pageControl
    }()

     var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let screenWidth = UIScreen.main.bounds.width
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    /// Set Up Constraints of UI Elements.
    private func setConstraints() {
        let screenHeight = screenHeight

        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            backButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
                                    ])

        self.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])

        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])

        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            skipButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        ])

        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: screenHeight * 0.02),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -screenHeight * 0.02)
        ])
    }

}
