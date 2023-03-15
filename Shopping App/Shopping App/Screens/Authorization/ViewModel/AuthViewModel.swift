//
//  AuthViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 1.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - Enums

/// Label Strings for Text Fields in the Authorization Screen.
enum AuthTextViewTitles: String, RawRepresentable {
    case username = "Username"
    case email = "E-mail"
    case password = "Password"
    case passwordAgain = "Re-Type your password"
    case birthday = "Birthday"
}

/// Button Titles for the Buttons in the Authorization Screen.
enum AuthButtonTitles: String, RawRepresentable {
    case forgotPasswordButton = "Forgot password?"
    case dontYouHaveAnAccountButton = "Don't you have an account?"
    case alreadyHaveAnAccountButton = "Already have an account?"
    case logInButton = "Log In"
    case signUpButton = "Sign Up"
}

// MARK: - Delegate Protocol
/// Delegate to handle actions on ViewController with the network responses of ViewController
protocol AuthDelegate: AnyObject {
    func isSignUpSuccessful()
    func isLogInSuccessful()
    func didErrorOccured(_ error: Error)
}
// Used delegate because i needed more than one functions to be used and also it's easier to test.

// MARK: - AuthViewModel
final class AuthViewModel {

    // MARK: - Properties
    weak var delegate: AuthDelegate?
    private let defaults = UserDefaults.standard
    // swiftlint:disable:next identifier_name
    private let db = Firestore.firestore()

    /// Sends a Sign In request to Firebase Auth and handles the possible outcomes with delegate.
    /// If Log In is successful, saves the uid to UserDefaults
    /// - Parameters:
    ///     - email: The subject to be welcomed.
    ///     - password: user's password
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
                return }

            guard let id = authResult?.user.uid else { return }

            self.defaults.set(id, forKey: "uid")
            self.delegate?.isLogInSuccessful()
        }
    }
/**
    Sends a Sign Up request to Firebase Auth and handles the possibe outcomes with delegate.
    If there is no error, creates a User instance, encodes the user struct as a dictionary and uploads that user
    information to Firebase Firestore as a dictionary.
 */
    func signUp(username: String, email: String, password: String, birthday: String) {

        // Create user on Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.delegate?.didErrorOccured(error)
                return
            }

            let user = User(username: username,
                            email: email,
                            birthday: "") // Init user struct

            do {
                guard let data = try user.dictionary, // encode user as dictionary.
                      let id = authResult?.user.uid else { return } // get Firebase Auth user unique id.

                self.defaults.set(id, forKey: "uid")

                self.db.collection("users").document(id).setData(data) { error in

                    if let error = error {
                        self.delegate?.didErrorOccured(error)
                    } else {
                        self.delegate?.isSignUpSuccessful()
                    }
                }
            } catch {
                self.delegate?.didErrorOccured(error)
            }
        }
    }
}
