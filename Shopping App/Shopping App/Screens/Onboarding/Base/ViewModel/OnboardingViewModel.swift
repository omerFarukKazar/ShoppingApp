//
//  OnboardingViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 21.02.2023.
//

import Foundation

/// This enum contains cases for the onboarding pages.
enum OnboardingPage: Int, RawRepresentable, CaseIterable {
    case firstPage = 0, secondPage, thirdPage

    /// Switches the page cases and returns the PageModel Instance created by enum's case's own data.
    func getPageData() -> PageModel {
        switch self {
        case .firstPage:
            return PageModel(imageName: "variousProducts",
                             headingTitle: "Various Products",
                             subheadingTitle: "You can find any high quality product that you are looking for.")
        case .secondPage:
            return PageModel(imageName: "fastDelivery",
                             headingTitle: "Fast Delivery",
                             subheadingTitle: "Your order will be delivered in 2-3 work days.")
        case .thirdPage:
            return PageModel(imageName: "customerService",
                             headingTitle: "7 / 24 Customer Service",
                             subheadingTitle: "We are here to guarantee customer satisfaction.")
        }
    }
}

struct OnboardingViewModel {

}
