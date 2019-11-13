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

    func skiptestInitialView() {
        let offDescription = app.tables[offDescriptionText]
        waitForElementToAppear(offDescription)
        XCTAssert(offDescription.exists)
    }

    func skiptestResultCellExists() {
        let searchField = app.searchFields[AccessibilityIdentifiers.Search.inputField]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(searchQuery)

        let productName = app.cells.staticTexts[cellProductName]
        waitForElementToAppear(productName)
        XCTAssert(productName.exists)
    }

//    func skiptestCancellingASearchDisplaysInitialView() {
//        let searchField = app.searchFields[AccessibilityIdentifiers.productSearchBar]
//        XCTAssert(searchField.exists)
//        searchField.tap()
//        searchField.typeText(searchQuery)
//
//        app.buttons["Cancel"].tap()
//
//        let offDescription = app.tables[offDescriptionText]
//        waitForElementToAppear(offDescription)
//        XCTAssert(offDescription.exists)
//    }

    func skiptestTappingScanButtonShowsScanView() {
        addUIInterruptionMonitor(withDescription: "Scanning setup failed because no camera was found") { (alert) -> Bool in
            alert.buttons["Leave barcode scanning"].tap()
            return true
        }

        app.tabBars.firstMatch.buttons.element(boundBy: 1).tap()
        app.tap()
    }

    func skiptestResponseWithErrorShowsErrorView() {
        dynamicStubs.setupErrorStub(url: "/cgi/search.pl")

        let searchField = app.searchFields[AccessibilityIdentifiers.Search.inputField]
        XCTAssert(searchField.exists)
        searchField.tap()
        searchField.typeText(searchQueryForError)

        let errorText = app.tables[self.errorText]
        waitForElementToAppear(errorText)
        XCTAssert(errorText.exists)
    }
}
