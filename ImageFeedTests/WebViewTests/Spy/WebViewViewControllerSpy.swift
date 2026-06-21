//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Nikler on 6/16/26.
//

@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadAuthViewCalled = false

    func loadAuthView(with request: URLRequest) {
        loadAuthViewCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
