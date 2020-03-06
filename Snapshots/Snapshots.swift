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
        
        // We only perform a snapshot for a locale that has an already existing configuration
        if let config = snapshotConfiguration {
            let app = XCUIApplication()
            let tabBar = app.tabBars.firstMatch

            // At the moment the scanner snapshot is crashing (06/03/2020)
            // performScannerSnapshots(with: config, app: app, tabBar: tabBar)
            performHistorySnapshots(with: config, app: app, tabBar: tabBar)
            performSearchSnapshots(with: config, app: app, tabBar: tabBar)
        }
    }
    
    private func performScannerSnapshots(with config: SnapshotConfiguration, app: XCUIApplication, tabBar: XCUIElement) {
        // TODO: Go to the allergen section
        // TODO: Define an allergen
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
    }
    
    private func performHistorySnapshots(with config: SnapshotConfiguration, app: XCUIApplication, tabBar: XCUIElement) {
        // Switch to the History tab and take a screenshot after all the products have been loaded
        let historyButton = tabBar.buttons.element(boundBy: 2)
        historyButton.tap()
        snapshot("03-History")
    }
    
    private func performSearchSnapshots(with config: SnapshotConfiguration, app: XCUIApplication, tabBar: XCUIElement) {
        // Only perform snapshots of the search functionality when we have
        if let searchKeyword = config.searchKeyword {
            // Switch to the search tab and take a screenshot with the results of a specific keyword
            let searchButton = tabBar.buttons.element(boundBy: 0)
            searchButton.tap()

            let searchField = app.searchFields.firstMatch
            searchField.tap()
            searchField.typeText(searchKeyword + "\n")
            
            // Wait for the results to display
            sleep(1)
            
            snapshot("04-Search")
        }
    }
}
