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
    private var pagesArray: [OnboardingPageView] = []

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
