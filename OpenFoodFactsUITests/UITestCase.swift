//
//  UITestCase.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 24/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {
    let app = XCUIApplication()
    let dynamicStubs = HTTPDynamicStubs()

    let searchQuery = "Fanta"
    let cellProductName = "Fanta Orange"

    override func setUp() {
        super.setUp()
        dynamicStubs.setUp()
        continueAfterFailure = false
        app.launchEnvironment = ["UITesting" : "true"]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        dynamicStubs.tearDown()
        app.terminate()
    }

    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        _ = app.staticTexts.count // force cached accessibility hierarchy refresh
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: 5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}
