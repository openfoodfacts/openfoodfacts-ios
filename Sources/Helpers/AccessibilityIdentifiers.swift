//
//  AccessibilityIdentifiers.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 25/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct AccessibilityIdentifiers {
    struct Product {
        static let detailSummaryView = "productDetailSummaryView"
        static let detailIngredientsView = "productDetailIngredientsView"
        static let detailNutritionView = "productDetailNutritionView"
    }
    struct Scan {
        static let manualBarcodeInputField = "scanManualBarcodeInputField"
        static let manualBarcodeConfirmButton = "scanManualBarcodeConfirmButton"

        static let overlayView = "scanOverlayView"
        static let productSummaryView = "scanProductSummaryView"
    }

    struct Search {
        static let inputField = "searchInputField"
        static let resultTable = "searchResultsTable"
    }
}
