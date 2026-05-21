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

final class WebViewViewController: UIViewController {
    private lazy var webView = createWebView()
    private lazy var progressView = createProgressView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUISubviews()

        observeEstimatedProgressChanges()
        loadAuthView()
    }

    private func observeEstimatedProgressChanges() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: []
        ) { [weak self] _, _ in
            self?.updateProgress()
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        let request = ApiRequests.loadAuthWebPageRequest()
        
        webView.load(request.originalRequest)
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
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
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
