//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private let profileService: ProfileService = .shared
    private let loadingService: LoadingService = .shared
    private let networkAuthStorage: NetworkAuthStorage = .shared

    private let showAuthViewSegueIdentifier = "ShowAuthView"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = networkAuthStorage.authToken else {
            return showAuthentication()
        }
        
        fetchProfile { [weak self] in
            self?.switchToTabBarController()
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
    
    private func fetchProfile(completion: @escaping () -> ()) {
        let loadingService = self.loadingService
        
        loadingService.showProgress()
        
        profileService.fetchProfile {
            defer { loadingService.hideProgress() }

            guard case .success = $0 else {
                return
            }
            
            completion()
        }
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
        
        fetchProfile { [weak self] in
            self?.switchToTabBarController()
        }
    }
}
