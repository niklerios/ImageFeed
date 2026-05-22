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
    
    private lazy var logoImageView = createLogoImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSubviews()
    }
    
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
        guard
            let authViewController = UIStoryboard.viewController(AuthViewController.self)
        else {
            assertionFailure("Не удалось создать AuthViewController из сториборда")
            return
        }
        
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.activeKeyWindow else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = UIStoryboard.abstractViewController(TabBarController.self)
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

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismissOrPop()
        
        fetchProfile { [weak self] in
            self?.switchToTabBarController()
        }
    }
}

extension SplashViewController {
    private func createLogoImageView() -> UIImageView {
        let image = UIImage(resource: .vector)
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func setupSubviews() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBlack
    }
}
