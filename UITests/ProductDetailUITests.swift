//
//  ProductDetailUITests.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 26/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest

class ProductDetailUITests: UITestCase {

    func skiptestSummaryPage() {
        showDetailsOfProduct(in: "GET_ProductsByNameOnlyOne_200")

        let barcode = app.staticTexts["Barcode: 5449000011527"]
        XCTAssert(barcode.exists)
    }

    func skiptestIngredientsPage() {
        showDetailsOfProduct(in: "GET_ProductsByNameOnlyOne_200")

        let ingredients = app.staticTexts["Ingredients"]
        ingredients.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()

        let additives = app.staticTexts["Additives: E160, E202, E412, E950, E955"]
        XCTAssert(additives.exists)
    }

    func skiptestNutritionPage() {
        showDetailsOfProduct(in: "GET_ProductsByNameOnlyOne_200")

        let nutrition = app.staticTexts["Nutrition"]
        nutrition.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
        let sugarQuantity = app.staticTexts["6.5 "]
        XCTAssert(sugarQuantity.exists)
    }

    func skiptestNutritionTablePage() {
        showDetailsOfProduct(in: "GET_ProductsByNameOnlyOne_200")

        let nutritionTable = app.staticTexts["Nutrition table"]
        nutritionTable.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
        let carbohydrateLabel = app.staticTexts["Carbohydrate"]
        XCTAssert(carbohydrateLabel.exists)
    }

    func skiptestNutritionPageNotShownWhenItHasNoData() {
        showDetailsOfProduct(in: "GET_ProductsByNameNoNutrition_200")

        XCTAssertFalse(app.staticTexts["Nutrition"].exists)
    }

    private func showDetailsOfProduct(in filename: String) {
        dynamicStubs.setupStub(url: "/cgi/search.pl", filename: filename, method: .GET)

        let searchField = app.searchFields[AccessibilityIdentifiers.Search.inputField]
        searchField.tap()
        searchField.typeText(searchQuery)

        waitForElementToAppear(app.staticTexts[cellProductName])

        let cell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts[cellProductName]
        cell.tap()
    }
}
