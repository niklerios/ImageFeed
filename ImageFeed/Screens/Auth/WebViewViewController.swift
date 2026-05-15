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
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUISubviews()

        loadAuthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        let url = NetworkURL.base(path: "/oauth/authorize") { queryBuilder in
            queryBuilder
                .add(.client_id, Constants.accessKey)
                .add(.redirect_uri, Constants.redirectURI)
                .add(.response_type, "code")
                .add(.scope, Constants.accessScope)
        }.url
        
        webView.load(URLRequest(url: url))
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
