//
//  UIViewController+dismissOrPop.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

extension UIViewController {
    func dismissOrPop(animated: Bool = true) {
        guard
            let navigationController,
            navigationController.viewControllers.first != self
        else {
            dismiss(animated: animated)
            return
        }
        
        navigationController.popViewController(animated: animated)
    }
}
