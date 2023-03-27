//
//  AppDelegate.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 7.02.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    var window: UIWindow? // Created window here because it is deleted with the SceneDelegate.swift file.

    // MARK: - Methods
    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        syncCart()
        syncFavorites()
        // Override point for customization after application launch.
        // swiftlint:disable:next void_function_in_ternary
        UserDefaults.standard.bool(forKey: "didOnboardingCompleted") ? setWindow() : setWindowForFirstRun()
        return true
    }

    /// Does the necessarry settings for window to present the viewController properly.
    private func setWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds) // Created a temporary window and defined the bounds.
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController(viewModel: viewModel)
//        let viewModel = AuthViewModel()
//        let viewController = AuthViewController(viewModel: viewModel)
        //        let viewModel = CartViewModel()
        //        let viewController = CartViewController(viewModel: viewModel)
        // Got an instance of the first screen's ViewController.
        let navigationController = UINavigationController(rootViewController: viewController)
        // Embedded view controller into a navigation controller.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window // Assigned the temporary window to AppDelegate's window.
    }

    /// Does the necessarry settings for window to present the viewController if onboarding isn't completed before.
    private func setWindowForFirstRun() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = OnboardingViewController(viewModel: OnboardingViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    private func syncCart() {
        ProductsManager().fetchCart { error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    private func syncFavorites() {
        ProductsManager().fetchFavoritesFromDB { error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
}
