//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Nikler on 6/16/26.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private var app: XCUIApplication!
    private var helper: TestHelper!
    private var envs: EnvHelper!
    
    private let defaultTimeout: Double = 5

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        
        app = XCUIApplication()
        helper = TestHelper(app: app)
        envs = EnvHelper()
        
        guard envs.isAllEnvsSet else {
            XCTFail("Проверьте ,заполнены ли следующие переменные окружения: \(envs.allEnvNames)")
            return
        }
        
        app.launchEnvironment["ACCESS_KEY"] = envs[name: .accessKey]
        app.launchEnvironment["SECRET_KEY"] = envs[name: .secretKey]

        app.launch()
    }
    
    override func tearDownWithError() throws {
            try super.tearDownWithError()
            
            app.terminate()
            app = nil
        }

    func testAuth() throws {
        app.buttons[Ids.authButton].tap()
        
        let webView = app.webViews[Ids.webView]
        
        XCTAssertTrue(webView.waitForExistence(timeout: defaultTimeout))
        
        let loginTextField = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: defaultTimeout))
        
        loginTextField.tap()
        loginTextField.typeText(envs[name: .email])
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: defaultTimeout))

        passwordTextField.tap()
        passwordTextField.typeText(envs[name: .password])
        
        let loginButton = helper.findButton(of: webView, withId: Ids.webViewLogin)
        
        loginButton.tap()
        
        helper.testImagesFeedShowed()
    }
    
    func testFeed() throws {
        let firstCell = helper.findCell()
        
        let testLike = {
            let likeButtonBeforeTap = self.helper.findButton(of: firstCell, withId: Ids.likeButton)
            let isLikedBeforeTap = self.helper.isLiked(likeButtonBeforeTap)
            
            likeButtonBeforeTap.tap()
            
            let likeButtonAfterTap = self.helper.findButton(of: firstCell, withId: Ids.likeButton)
            let isLikedAfterTap = self.helper.isLiked(likeButtonAfterTap)
            
            XCTAssertNotEqual(isLikedBeforeTap, isLikedAfterTap)
        }
        
        testLike() // test like
        testLike() // test unlike
        
        firstCell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        XCTAssertTrue(image.waitForExistence(timeout: defaultTimeout))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons[Ids.backButton].tap()
        
        helper.testImagesFeedShowed()
    }
    
    func testProfile() throws {
        helper.testImagesFeedShowed()
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let logoutButton = helper.findButton(of: app, withId: Ids.logoutButton)
        
        XCTAssertTrue(app.staticTexts[envs[name: .username]].waitForExistence(timeout: defaultTimeout))
        XCTAssertTrue(app.staticTexts[envs[name: .userId]].waitForExistence(timeout: defaultTimeout))
        
        logoutButton.tap()
        
        let alert = app.alerts[Ids.logoutAlert]
        
        XCTAssertTrue(alert.waitForExistence(timeout: defaultTimeout))
        
        alert.scrollViews.otherElements.buttons[Ids.logoutAlertYes].tap()
        
        XCTAssertTrue(app.buttons[Ids.authButton].waitForExistence(timeout: defaultTimeout))
    }
}
