//
//  UIStoryboard+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: .main)
    }
    
    static func viewController<T: UIViewController>(
        _ viewController: T.Type,
        storyboard: UIStoryboard = .main
    ) -> T? {
        let identifier = String(describing: viewController)

        return main.instantiateViewController(withIdentifier: identifier) as? T
    }
    
    static func abstractViewController(
        _ viewController: UIViewController.Type,
        storyboard: UIStoryboard = .main
    ) -> UIViewController {
        let identifier = String(describing: viewController)

        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
