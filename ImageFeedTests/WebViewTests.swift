//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Nikler on 6/16/26.
//

@testable import ImageFeed
import XCTest

@MainActor
final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = UIStoryboard.viewController(WebViewViewController.self)!
        let presenter = WebViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadAuthViewCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration: AuthConfiguration = .standard
        let authHelper = AuthHelper(configuration: configuration)
        let url = authHelper.authRequest().url
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        XCTAssertTrue(urlString.contains(configuration.authPathString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        let authHelper = AuthHelper()
        let expectedCode = "test code"
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: expectedCode)
        ]
        
        let code = authHelper.code(from: urlComponents.url!)
        
        XCTAssertEqual(code, expectedCode)
    }
}
