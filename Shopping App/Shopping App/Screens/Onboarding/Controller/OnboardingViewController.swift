//
//  OnboardingViewController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 8.02.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {

    var onboardingView = OnboardingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllerSettings()
    }

    // MARK: - Methods
    func setupControllerSettings() {
        view = onboardingView
    }
    
}
