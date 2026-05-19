//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthViewSegueIdentifier = "ShowAuthView"
    
    var authToken: String? {
        NetworkAuthStorage.shared.authToken
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authToken != nil {
            switchToTabBarController()
        } else {
            showAuthentication()
        }
    }

    private func showAuthentication() {
        performSegue(withIdentifier: showAuthViewSegueIdentifier, sender: nil)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.activeKeyWindow else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = UIStoryboard.instantiate(UITabBarController.self)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare \(showAuthViewSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismissOrPop()
        switchToTabBarController()
    }
}
