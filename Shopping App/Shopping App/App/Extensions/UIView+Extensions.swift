//
//  UIView+Extensions.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 9.02.2023.
//

import UIKit

// Since screenWidth and screenHeight will be used a lot in different ViewControllers for reactive layout design, this extension added.
// Maybe in the future, Custom View can be created.

extension UIView {

    // MARK: - Properties
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

}
