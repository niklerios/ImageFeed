//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Alfa on 08.05.2026.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAutenticateWithCode code: String
    )
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func loadAuthView(with request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    private lazy var webView = createWebView()
    private lazy var progressView = createProgressView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUISubviews()

        observeEstimatedProgressChanges()
        presenter?.viewDidLoad()
    }

    private func observeEstimatedProgressChanges() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: []
        ) { [weak self] _, _ in
            guard let self, let presenter = self.presenter else { return }
            let progressValue = self.webView.estimatedProgress

            presenter.didUpdateProgressValue(progressValue)
        }
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func loadAuthView(with request: URLRequest) {
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAutenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        
        return nil
    }
}

// MARK: - UI Settings
extension WebViewViewController {
    private func setupUI() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupUISubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        setupSubviewsConstraints()
    }

    private func createWebView() -> WKWebView {
        let webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .ypWhite
        webView.navigationDelegate = self
        
        webView.accessibilityIdentifier = AccessibilityIdentifier.webView
        
        return webView
    }
    
    private func createProgressView() -> UIProgressView {
        let view = UIProgressView(progressViewStyle: .default)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .ypBlack
        
        return view
    }
    
    private func setupSubviewsConstraints() {
        NSLayoutConstraint.activate([
            // webView
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            
            // progressView
            progressView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }
}
