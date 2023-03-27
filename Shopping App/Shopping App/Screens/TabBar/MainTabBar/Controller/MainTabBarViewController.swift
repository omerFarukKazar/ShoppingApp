//
//  MainTabBarController.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.03.2023.
//

import UIKit

/// Titles for the TabBar
enum TabBarTitles: String, RawRepresentable {
    case products = "Products"
    case search = "Search"
    case profile = "Profile"
}

/// Cases for assets in the MainTabBarAsset.
enum TabBarImageNames: String {
    case priceTag
    case search
    case profile
}

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarControllers()
    }

    // MARK: - Methods
    /// Instantiates tab bar controllers, adds titles and images.
    /// Adds them into UITabBarController.
    private func setTabBarControllers() {
        // Instantiate ViewControllers for each tab.
        let productsViewModel = ProductsViewModel(service: ProductsService())
        let productsViewController = ProductsViewController(viewModel: productsViewModel)
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
//        self.navigationController?.navigationBar = productsNavigationController.navigationBar

        let searchViewController = SearchViewController()
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)

        let profileViewModel = ProfileViewModel()
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        // Set titles for each tab.
        productsViewController.title = TabBarTitles.products.rawValue
        searchViewController.title = TabBarTitles.search.rawValue
        profileViewController.title = TabBarTitles.profile.rawValue

        // Set images for each tab.
        productsViewController.tabBarItem.image = UIImage(named: TabBarImageNames.priceTag.rawValue)
        searchViewController.tabBarItem.image = UIImage(named: TabBarImageNames.search.rawValue)
        profileViewController.tabBarItem.image = UIImage(named: TabBarImageNames.profile.rawValue)

        let viewControllerArray = [productsNavigationController, searchNavigationController, profileNavigationController]

        self.setViewControllers(viewControllerArray, animated: true)

    }

}
