//
//  ProductDetailUITests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 26/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class ProductDetailUITests: UITestCase {

    override func setUp() {
        super.setUp()

        dynamicStubs.setupStub(url: "/cgi/search.pl", filename: "GET_ProductsByNameOnlyOne_200", method: .GET)

        let searchField = app.searchFields[AccessibilityIdentifiers.productSearchBar]
        searchField.tap()
        searchField.typeText(searchQuery)

        waitForElementToAppear(app.staticTexts[cellProductName])

        let cell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts[cellProductName]
        cell.tap()
    }

    func testSummaryPage() {
        let barcode = app.staticTexts["Barcode: 5449000011527"]
        XCTAssert(barcode.exists)
    }

    func testIngredientsPage() {
        app.staticTexts["Ingredients"].tap()
        let additives = app.staticTexts["Additives: E160, E202, E412, E950, E955"]
        XCTAssert(additives.exists)
    }

    func testNutritionPage() {
        app.staticTexts["Nutrition"].tap()
        let sugarQuantity = app.staticTexts["6.5 "]
        XCTAssert(sugarQuantity.exists)
    }

    func testNutritionTablePage() {
        app.staticTexts["Nutrition table"].tap()
        let carbohydrateLabel = app.staticTexts["Carbohydrate"]
        XCTAssert(carbohydrateLabel.exists)
    }
}
