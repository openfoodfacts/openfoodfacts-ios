//
//  Snapshots.swift
//  Snapshots
//
//  Created by Clément Aubin on 26/08/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest


class Snapshots: XCTestCase {

    override func setUp() {
        // Initialize fastlane screenshot utility
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["debug"]
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDown() {

    }

    func testSnapshots() {
        // Look for a snapshot configuration that corresponds to the configured locale
        let snapshotConfiguration = SnapshotConfigurations().configurations.filter {
            (sc: SnapshotConfiguration) -> Bool in
            sc.locale == locale
        }.first
        
        if let config = snapshotConfiguration {
            performSnapshotTest(withConfiguration: config)
        }
    }

    func performSnapshotTest(withConfiguration config: SnapshotConfiguration) {
        let app = XCUIApplication()
        let tabBar = app.tabBars.firstMatch
        
        // TODO: Go to the allergen section
        // TODO: Define an allergen
        // Go back to home
        for (index, productCode) in config.productCodes.enumerated() {
            // Get the search field, and type in the product code
            // Switch to the Scanner view
            let scanButton = tabBar.buttons.element(boundBy: 1)
            scanButton.tap()
            sleep(1)
            
            // Input the barcode of the product
            let manualBarcodeInputTextField = app.textFields[AccessibilityIdentifiers.Scan.manualBarcodeInputField]
            manualBarcodeInputTextField.tap()
            manualBarcodeInputTextField.typeText(productCode)
            
            let manualBarcodeConfirmButton = app.buttons[AccessibilityIdentifiers.Scan.manualBarcodeConfirmButton]
            manualBarcodeConfirmButton.tap()
            sleep(1)
            
            // TODO: include gh.com/shinydevelopment/SimulatorStatusMagic
            // TODO: Add in app code a debug enable switch that downloads
            /* https://static.openfoodfacts.org/images/products/325/798/416/3031/1.jpg */
            // Do not snapshot beyond the first product of the list to save time
            if index == 0 {
                snapshot("01-ScannerView-" + productCode)
                
                let productSummaryView = app.otherElements[AccessibilityIdentifiers.Scan.productSummaryView]
                let scanOverlay = app.otherElements[AccessibilityIdentifiers.Scan.overlayView]
                productSummaryView.press(forDuration: 0.5, thenDragTo: scanOverlay)
                sleep(1)
                
                snapshot("02-ProductView-" + productCode)
            }
            
            /*
             let ingredientsTab = app.otherElements["Product detail ingredients view"]
             XCTAssert(ingredientsTab.exists)
             ingredientsTab.tap()
             sleep(2)
             
             snapshot("03-IngredientsView-" + productCode)
             
             let nutritionTab = app.tabs["Product detail nutrition view"]
             XCTAssert(nutritionTab.exists)
             nutritionTab.tap()
             sleep(2)
             
             snapshot("04-NutritionView-" + productCode)
             */
            
            // Go back to the search and erase everything so that the interface is clean for the next product.
            sleep(1)
            let searchButton = tabBar.buttons.element(boundBy: 0)
            searchButton.tap()
        }
        
        // Switch to the History tab and take a screenshot after all the products have been loaded
        let historyButton = tabBar.buttons.element(boundBy: 2)
        historyButton.tap()
        snapshot("03-History")
        
        // Switch to the search tab and take a screenshot with the results of a specific keyword
        let searchButton = tabBar.buttons.element(boundBy: 0)
        searchButton.tap()
        // TODO add  in the right place (already in accessibility identifiers)
        //confirmButton.accessibilityIdentifier = AccessibilityIdentifiers.manualSearchInputConfirmButton
        //barcodeTextField.accessibilityIdentifier = AccessibilityIdentifiers.manualSearchInputField
        snapshot("04-SearchScreen-" + queryName)
        
        sleep(2)
    }
}
