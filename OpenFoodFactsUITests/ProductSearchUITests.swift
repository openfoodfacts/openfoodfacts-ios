//
//  OpenFoodFactsUITests.swift
//  OpenFoodFactsUITests
//
//  Created by Andrés Pizá Bückmann on 23/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class ProductSearchUITests: UITestCase {

    private let offDescriptionText = "Open Food Facts is an open database of food products with ingredients, allergens, nutrition facts and all the tidbits of information we can find on product labels."
    private let searchQueryForError = "Sprite"
    private let errorText = "Something went wrong, Please try again"

    func testInitialView() {
        let offDescription = app.tables[offDescriptionText]
        waitForElementToAppear(offDescription)
        XCTAssert(offDescription.exists)
    }

    func testResultCellExists() {
        let searchField = app.searchFields[AccessibilityIdentifiers.productSearchBar]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(searchQuery)

        let productName = app.cells.staticTexts[cellProductName]
        waitForElementToAppear(productName)
        XCTAssert(productName.exists)
    }

    func testCancellingASearchDisplaysInitialView() {
        let searchField = app.searchFields[AccessibilityIdentifiers.productSearchBar]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(searchQuery)

        app.buttons["Cancel"].tap()

        let offDescription = app.tables[offDescriptionText]
        waitForElementToAppear(offDescription)
        XCTAssert(offDescription.exists)
    }

    func testTappingScanButtonShowsScanView() {
        app.buttons[AccessibilityIdentifiers.scanButton].tap()
        XCTAssert(app.navigationBars["OpenFoodFacts.ScannerView"].exists)
    }

    func testResponseWithErrorShowsErrorView() {
        dynamicStubs.setupErrorStub(url: "/cgi/search.pl")

        let searchField = app.searchFields[AccessibilityIdentifiers.productSearchBar]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(searchQueryForError)

        let errorText = app.tables[self.errorText]
        waitForElementToAppear(errorText)
        XCTAssert(errorText.exists)
    }
}
