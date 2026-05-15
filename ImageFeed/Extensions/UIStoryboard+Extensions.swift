//
//  UIStoryboard+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

extension UIStoryboard {
    static func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
