//
//  AuthViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 1.03.2023.
//

import Foundation

final class AuthViewModel {

    /// Auth
    enum AuthOption: String {
        case logIn
        case signUp
    }

    /// Placeholder Strings for Text Fields.
    enum Placeholders: String, RawRepresentable {
        case username = "Username"
        case email = "E-mail"
        case password = "Password"
        case passwordAgain = "Re-Type your password"
        case birthday = "Birthday"
    }

    enum ButtonTitles: String, RawRepresentable {
        case forgotPasswordButton = "Forgot password?"
        case dontYouHaveAnAccountButton = "Don't you have an account?"
        case alreadyHaveAnAccountButton = "Already have an account?"
        case logInButton = "Log In"
        case signUpButton = "Sign Up"
    }

}
