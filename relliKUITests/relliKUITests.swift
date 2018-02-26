//
//  relliKUITests.swift
//  relliKUITests
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import XCTest

class relliKUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element
        element.swipeDown()
        element.tap()
        element.swipeRight()
        element.tap()
    }
}
