//
//  UIColor+Extensions.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 16.03.2023.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var alpha: CGFloat = 1.0

        // Check if the hex string has an alpha component
        if hexString.count == 8 {
            let alphaIndex = hexString.index(hexString.endIndex, offsetBy: -2)
            let alphaString = hexString[alphaIndex...]
            hexString = String(hexString[..<alphaIndex])

            if let alphaValue = UInt8(alphaString, radix: 16) {
                alpha = CGFloat(alphaValue) / 255.0
            }
        }

        // Convert the hex string to a UIColor
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
