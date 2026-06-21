//
//  TestHelper.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

import XCTest

final class TestHelper {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func findCell(index: Int = 0) -> XCUIElement {
        let cell = app.tables.children(matching: .cell).element(boundBy: index)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        return cell
    }
    
    func findButton(of element: XCUIElement, withId id: String) -> XCUIElement {
        let button = element.buttons[id]

        XCTAssertTrue(button.waitForExistence(timeout: 5))
        
        return button
    }
    
    func isLiked(_ element: XCUIElement) -> Bool {
        let value = element.value as? String
        
        XCTAssertNotNil(value)

        return value == "liked"
    }
    
    func testImagesFeedShowed() {
        let _ = findCell()
    }
}
