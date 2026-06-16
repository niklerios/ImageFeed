//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Nikler on 6/16/26.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}


final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        let request = ApiRequests.loadAuthWebPageRequest().originalRequest

        view?.loadAuthView(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        
        guard let view else { return }
        
        view.setProgressValue(newProgressValue)
        view.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        if
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
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
