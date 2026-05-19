//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alfa on 08.05.2026.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let oAuth2Service: OAuth2Service = .shared
    private let loadingService: LoadingService = .shared
    
    private lazy var logoImageView = createLogoImageView()
    private lazy var loginButton = createLoginButton()
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSubviews()
        configureNavigationBackButton()
    }
    
    @objc private func didTapLoginButton() {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAutenticateWithCode code: String
    ) {
        let loadingService = self.loadingService

        loadingService.showProgress()
        vc.dismissOrPop()

        oAuth2Service.fetchOAuthToken(with: code) { [weak self] result in
            defer { loadingService.hideProgress() }

            guard let self, case .success = result else {
                return
            }
            
            self.delegate?.didAuthenticate(self)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismissOrPop()
    }
}

// MARK: - UI Settings
extension AuthViewController {
    private func setupUI() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        
        setupSubviewsConstraints()
    }
    
    private func configureNavigationBackButton() {
        guard let nav = navigationController else {
            return
        }
        
        let backImage = UIImage(resource: .backButton)
        
        nav.navigationBar.backIndicatorImage = backImage
        nav.navigationBar.backIndicatorTransitionMaskImage = backImage

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func createLogoImageView() -> UIImageView {
        let image = UIImage(resource: .logo)
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func createLoginButton() -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        button.addTarget(
            self,
            action: #selector(Self.didTapLoginButton),
            for: .touchUpInside
        )
        
        return button
    }
    
    private func setupSubviewsConstraints() {
        let logoSize: CGFloat = 60
        let hInset: CGFloat = 16

        NSLayoutConstraint.activate([
            // logoImageView
            logoImageView.widthAnchor.constraint(
                equalToConstant: logoSize
            ),
            logoImageView.heightAnchor.constraint(
                equalToConstant: logoSize
            ),
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            
            // loginButton
            loginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -90
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: hInset
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -hInset
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: 48
            )
        ])
    }
}
