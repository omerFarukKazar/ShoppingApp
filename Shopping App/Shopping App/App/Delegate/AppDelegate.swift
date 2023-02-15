//
//  AppDelegate.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 7.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    var window: UIWindow? // Created window here because it is deleted with the SceneDelegate.swift file.

    // MARK: - Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setWindow()
        return true
    }

    /// Does the necessarry settings for window to present the viewController properly.
    func setWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds) // Created a temporary window and defined the bounds.
        let viewController = OnboardingViewController() // Got an instance of the first screen's ViewController.
        let navigationController = UINavigationController(rootViewController: viewController) // Embedded view controller into a navigation controller.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window // Assigned the temporary window to AppDelegate's window.
    }
}

