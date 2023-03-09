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
        // Override point for customization after application launch.
        // swiftlint:disable:next void_function_in_ternary
        UserDefaults.standard.bool(forKey: "didOnboardingCompleted") ? setWindow() : setWindowForFirstRun()
        return true
    }

    /// Does the necessarry settings for window to present the viewController properly.
    func setWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds) // Created a temporary window and defined the bounds.
        let viewController = AuthViewController(viewModel: AuthViewModel())
        // Got an instance of the first screen's ViewController.
        let navigationController = UINavigationController(rootViewController: viewController)
        // Embedded view controller into a navigation controller.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window // Assigned the temporary window to AppDelegate's window.
    }

    /// Does the necessarry settings for window to present the viewController if onboarding isn't completed before.
    func setWindowForFirstRun() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = OnboardingViewController(viewModel: OnboardingViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
