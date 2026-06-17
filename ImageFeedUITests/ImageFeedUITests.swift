//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Nikler on 6/16/26.
//

import XCTest

final class TestHelper {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func findCell(index: Int) -> XCUIElement {
        let cell = app.tables.children(matching: .cell).element(boundBy: index)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        return cell
    }
    
    func findButton(from element: XCUIElement, withId id: String) -> XCUIElement {
        let button = element.buttons[id]

        XCTAssertTrue(button.waitForExistence(timeout: 5))
        
        return button
    }
    
    func isLiked(_ element: XCUIElement) -> Bool {
        element.accessibilityValue == "liked"
    }
}

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    private let env = ProcessInfo.processInfo.environment

    private lazy var helper = TestHelper(app: app)
    
    private var email: String! { env["EMAIL"] }
    private var password: String! { env["PASSWORD"] }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchEnvironment["ACCESS_KEY"] = env["ACCESS_KEY"]
        app.launchEnvironment["SECRET_KEY"] = env["SECRET_KEY"]
        
        guard let _ = email, let _ = password else {
            XCTFail("Не заполнены переменные окружения EMAIL и PASSWORD!")
            return
        }

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        let loginButton = helper.findButton(from: webView, withId: "Login")
        
        loginButton.tap()
        
        let _ = helper.findCell(index: 0)
    }
    
    func testFeed() throws {
        let firstCell = helper.findCell(index: 0)
        
        let likeButtonBeforeTap = helper.findButton(from: firstCell, withId: "LikeButton")
        let isLikedBeforeTap = helper.isLiked(likeButtonBeforeTap)
        
        likeButtonBeforeTap.tap()
        
        let likeButtonAfterTap = helper.findButton(from: firstCell, withId: "LikeButton")
        let isLikedAfterTap = helper.isLiked(likeButtonAfterTap)
        
        XCTAssertNotEqual(isLikedBeforeTap, isLikedAfterTap)
    }
    
    func testProfile() throws {
        
    }
}
