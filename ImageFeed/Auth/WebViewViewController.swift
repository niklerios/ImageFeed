//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Alfa on 08.05.2026.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    // WebViewViewController получил код
    func webViewViewController(_ vc: WebViewViewController, didAutenticateWithCode code: String)
    // пользователь нажал кнопку назад и отменил авторизацию
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private lazy var webView = createWebView()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var unsplashAuthorizeURLComponents: URLComponents? {
        URLComponents(string: WebViewConstants.unsplashAuthorizeURLString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUISubviews()

        loadAuthView()
    }
    
    private func loadAuthView() {
        guard var components = unsplashAuthorizeURLComponents else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = components.url else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupUISubviews() {
        view.addSubview(webView)
        
        setupSubviewsConstraints()
    }
    
    private func createWebView() -> WKWebView {
        let webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .ypWhite
        webView.navigationDelegate = self
        
        return webView
    }
    
    private func setupSubviewsConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

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
