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
    case energy = "nutrition.energy"
    case fats = "nutrition.fats"
    case saturatedFats = "nutrition.fats.saturated-fat"
    case monoUnsaturatedFat = "nutrition.fats.mono-unsaturated-fat"
    case polyUnsaturatedFat = "nutrition.fats.poly-unsaturated-fat"
    case omega3 = "nutrition.fats.omega3"
    case omega6 = "nutrition.fats.omega6"
    case omega9 = "nutrition.fats.omega9"
    case transFat = "nutrition.fats.trans-fat"
    case cholesterol = "nutrition.fats.cholesterol"
    case carbohydrates = "nutrition.carbohydrate"
    case sugars = "nutrition.carbohydrate.sugars"
    case sucrose = "nutrition.carbohydrate.sucrose"
    case glucose = "nutrition.carbohydrate.glucose"
    case fructose = "nutrition.carbohydrate.fructose"
    case lactose = "nutrition.carbohydrate.lactose"
    case maltose = "nutrition.carbohydrate.maltose"
    case maltodextrins = "nutrition.carbohydrate.maltodextrins"
    case fiber = "nutrition.fiber"
    case proteins = "nutrition.proteins"
    case casein = "nutrition.proteins.casein"
    case serumProteins = "nutrition.proteins.serum-proteins"
    case nucleotides = "nutrition.proteins.nucleotides"
    case salt = "nutrition.salt"
    case sodium = "nutrition.sodium"
    case alcohol = "nutrition.alcohol"
    case a = "nutrition.vitamins.a"
    case betaCarotene = "nutrition.vitamins.beta-carotene"
    case d = "nutrition.vitamins.d"
    case e = "nutrition.vitamins.e"
    case k = "nutrition.vitamins.k"
    case c = "nutrition.vitamins.c"
    case b1 = "nutrition.vitamins.b1"
    case b2 = "nutrition.vitamins.b2"
    case pp = "nutrition.vitamins.pp"
    case b6 = "nutrition.vitamins.b6"
    case b9 = "nutrition.vitamins.b9"
    case b12 = "nutrition.vitamins.b12"
    case biotin = "nutrition.vitamins.biotin"
    case pantothenicAcid = "nutrition.vitamins.pantothenic-acid"
    case silica = "nutrition.minerals.silica"
    case bicarbonate = "nutrition.minerals.bicarbonate"
    case potassium = "nutrition.minerals.potassium"
    case chloride = "nutrition.minerals.chloride"
    case calcium = "nutrition.minerals.calcium"
    case phosphorus = "nutrition.minerals.phosphorus"
    case iron = "nutrition.minerals.iron"
    case magnesium = "nutrition.minerals.magnesium"
    case zinc = "nutrition.minerals.zinc"
    case copper = "nutrition.minerals.copper"
    case manganese = "nutrition.minerals.manganese"
    case fluoride = "nutrition.minerals.fluoride"
    case selenium = "nutrition.minerals.selenium"
    case chromium = "nutrition.minerals.chromium"
    case molybdenum = "nutrition.minerals.molybdenum"
    case iodine = "nutrition.minerals.iodine"
    case caffeine = "nutrition.minerals.caffeine"
    case taurine = "nutrition.minerals.taurine"
    case ph = "nutrition.minerals.ph"
    case fruitsVegetablesNuts = "nutrition.minerals.fruits-vegetables-nuts"
    case collagenMeatProteinRatio = "nutrition.minerals.collagen-meat-protein-ratio"
    case cocoa = "nutrition.minerals.cocoa"
    case chlorophyl = "nutrition.minerals.chlorophyl"
    
    case servingSize = "product-detail.nutrition.serving-size"
    case carbonFootprint = "product-detail.nutrition.carbon-footprint"
    
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
    var secondaryValue: String?
    let highlight: Bool
    
    init(label: InfoRowKey, value: String) {
        self.label = label
        self.value = value
        self.secondaryValue = nil
        self.highlight = false
    }
    
    init(label: InfoRowKey, value: String, secondaryValue: String?, highlight: Bool = false) {
        self.label = label
        self.value = value
        self.secondaryValue = secondaryValue
        self.highlight = highlight
    }
}
