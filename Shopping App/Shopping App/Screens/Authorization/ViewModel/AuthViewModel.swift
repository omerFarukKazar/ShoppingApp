//
//  AuthViewModel.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 1.03.2023.
//

import Foundation

final class AuthViewModel {

    /// Placeholder Strings for Text Fields.
    enum Placeholders: String, RawRepresentable {
        case username = "Username"
        case email = "E-mail"
        case password = "Password"
        case passwordAgain = "Re-Type your password"
    }

    enum ButtonTitles: String, RawRepresentable {
        case forgotPasswordButton = "Forgot password?"
        case logInButton = "Log In"
        case signUpButton = "Sign Up"
    }

    /// Auth
    enum AuthOption: String {
        case logIn
        case signUp

        var title: String {
            switch self {
            case .logIn:
                return "Log In"
            case .signUp:
                return "Sign Up"
            }
        }
    }

}
