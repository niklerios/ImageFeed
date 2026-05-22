//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alfa on 11.05.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private let profileService: ProfileService = .shared
    private let profileImageService: ProfileImageService = .shared
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
        // Удерживаем сильные ссылки на сервисы ,чтоб не зависеть от self в кложурах
        let loadingService = self.loadingService
        let profileImageService = self.profileImageService

        let authUsername = networkAuthStorage.username
        
        let fetchProfileImageURL: (String) -> () = { username in
            // По условию задачи нам не требуется ожидать завершения запроса
            profileImageService.fetchProfileImageURL(username: username)
        }
        
        // Если удалось забрать username из networkAuthStorage ,то запрашиваем аватар с ним
        if let authUsername {
            fetchProfileImageURL(authUsername)
        }
        
        loadingService.showProgress()
        
        profileService.fetchProfile {
            defer { loadingService.hideProgress() }

            guard case let .success(profile) = $0 else {
                self.showAuthentication()
                return
            }
            
            // Если в networkAuthStorage username отсутствует ,то запрашиваем автар отсюда
            if authUsername == nil {
                fetchProfileImageURL(profile.username)
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
