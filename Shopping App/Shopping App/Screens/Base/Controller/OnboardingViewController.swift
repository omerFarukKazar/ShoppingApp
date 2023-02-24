//
//  OnboardingViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.02.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Properties
    var onboardingView = OnboardingView()
    private let viewModel: OnboardingViewModel // Not used as an instance. That property could've been deleted.
    private var pageCount = OnboardingViewModel.Page.allCases.count
    private var pagesArray: [OnboardingPageView] = [] {
        didSet {
            setLayout()
        }
    }
    // MARK: - Init
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendPages()
        setupView()
    }

    // MARK: - Methods
    /// Sets the ViewController related settings of view.
    func setupView() {
        view = onboardingView
    }

    /// Sets the ScrollView's constraints(named as contentView) with respect to number of pages.
    func setLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfPages = pagesArray.count
        let contentView = onboardingView.scrollView

        contentView.contentSize.width = CGFloat(numberOfPages) * screenWidth
        onboardingView.pageControl.numberOfPages = numberOfPages

        guard let page = pagesArray.last else {
            fatalError("OnboardingView not found.")
        }

        contentView.addSubview(page)
        page.translatesAutoresizingMaskIntoConstraints = false

        // Sets the constraints of multiple pages. Since setLayout() function is called each time a new page is added to pagesArray, all pages' constraints set one by one.
        if numberOfPages == 1 { // Constraints for the first page.
            NSLayoutConstraint.activate([
                page.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                page.topAnchor.constraint(equalTo: contentView.topAnchor),
                page.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                page.widthAnchor.constraint(equalToConstant: screenWidth)
            ])
        } else if numberOfPages != pageCount && numberOfPages != 1 { // Constraints for the pages between first and last.
            NSLayoutConstraint.activate([
                page.leadingAnchor.constraint(equalTo: pagesArray[numberOfPages - 2].trailingAnchor),
                page.topAnchor.constraint(equalTo: contentView.topAnchor),
                page.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                page.widthAnchor.constraint(equalToConstant: screenWidth)
            ])
        } else { // Constraints for the last page.
            NSLayoutConstraint.activate([
                page.leadingAnchor.constraint(equalTo: pagesArray[numberOfPages - 2].trailingAnchor),
                page.topAnchor.constraint(equalTo: contentView.topAnchor),
                page.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                page.widthAnchor.constraint(equalToConstant: screenWidth),
                page.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
        }
    }

    /// Initiates pageview's with the data on Page enum. Then appends pages to the pagesArray one by one.
    func appendPages() {
        let pageModelsArray = OnboardingViewModel.Page.allCases // loop range.

        // One by one, initiates each page's view with the corresponding data on Page enum and appends the view into pagesArray
        for page in pageModelsArray {
            let pageData = page.getPageData()
            let pageView = OnboardingPageView()

            pageView.image = UIImage(named: pageData.imageName ?? "imagePlaceholder")
            pageView.headingTitle = pageData.headingTitle
            pageView.subheadingTitle = pageData.subheadingTitle
            pagesArray.append(pageView)
        }
    }

}
