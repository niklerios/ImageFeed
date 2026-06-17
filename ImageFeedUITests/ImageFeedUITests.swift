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
    private let env = ProcessInfo.processInfo.environment

    private var app: XCUIApplication!
    private var helper: TestHelper!
    
    private var email: String! { env["EMAIL"] }
    private var password: String! { env["PASSWORD"] }

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        
        app = XCUIApplication()
        helper = TestHelper(app: app)
        
        app.launchEnvironment["ACCESS_KEY"] = "_gCXQNZHKgHxhPK3ybCgfkjmSBE7efPIXrHf5jaTlTM"
        app.launchEnvironment["SECRET_KEY"] = "jTFfwHJ6PtCxrn0xhvArUemv9YqXVOeutK-qeoajrpU"
        
        guard let _ = email, let _ = password else {
            XCTFail("Не заполнены переменные окружения EMAIL и PASSWORD!")
            return
        }

        app.launch()
    }
    
    override func tearDownWithError() throws {
            try super.tearDownWithError()
            
            app.terminate()
            app = nil
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
        
        sleep(2)
        
        likeButtonBeforeTap.tap()
        
        sleep(2)
        
        let likeButtonAfterTap = helper.findButton(from: firstCell, withId: "LikeButton")
        let isLikedAfterTap = helper.isLiked(likeButtonAfterTap)
        
        XCTAssertNotEqual(isLikedBeforeTap, isLikedAfterTap)
    }
    
    func testProfile() throws {
        
    }
}
