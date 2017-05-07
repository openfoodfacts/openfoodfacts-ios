//
//  ProductInfo.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

enum InfoRowKey: LocalizedString {
    // Summary
    case barcode = "product-detail.summary.barcode"
    case quantity = "product-detail.summary.quantity"
    case packaging = "product-detail.summary.packaging"
    case brands = "product-detail.summary.brands"
    case manufacturingPlaces = "product-detail.summary.manufacturing-places"
    case origins = "product-detail.summary.origins"
    case categories = "product-detail.summary.categories"
    case labels = "product-detail.summary.labels"
    case citiesTags = "product-detail.summary.citiesTags"
    case stores = "product-detail.summary.stores"
    case countries = "product-detail.summary.countries"
    
    // Ingredients
    case ingredientsList = "product-detail.ingredients.ingredients-list"
    case allergens = "product-detail.ingredients.allergens-list"
    case traces = "product-detail.ingredients.traces-list"
    case additives = "product-detail.ingredients.additives-list"
    case palmOilIngredients = "product-detail.ingredients.palm-oil-ingredients"
    case possiblePalmOilIngredients = "product-detail.ingredients.possible-palm-oil-ingredients"
    
    // Nutrition
    case servingSize = "product-detail.nutrition.serving-size"
    
    var localizedString: String {
        return self.rawValue.v
    }
    
    init?(localizedString: String) {
        self.init(rawValue: LocalizedString(localized: localizedString))
    }
}

struct InfoRow {
    let label: InfoRowKey
    let value: String
}
