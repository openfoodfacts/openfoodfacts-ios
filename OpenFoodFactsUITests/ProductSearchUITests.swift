//
//  OpenFoodFactsUITests.swift
//  OpenFoodFactsUITests
//
//  Created by Andrés Pizá Bückmann on 23/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class ProductSearchUITests: UITestCase {

    func testResultCellExists() {
        let searchField = app.searchFields["Product Search Bar"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("Fanta")

        let productName = app.cells.staticTexts["Fanta Orange"]
        waitForElementToAppear(productName)
        XCTAssertTrue(productName.exists)
    }
}
