//
//  UIApplication+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

extension UIApplication {
    @available(iOS, deprecated: 13.0)
    var keyWindowLegacy: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    var activeKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?
            .keyWindow
    }
}
