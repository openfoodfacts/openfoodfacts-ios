//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

enum NutritionDataPer: String {
    case hundredGrams = "100g"
    case serving = "serving"
}

enum EnvironmentImpact: String {
    case low = "en-low"
    case medium = "en-medium"
    case high = "en-high"

    var image: UIImage {
        switch self {
        case .low: return UIImage(named: "co2-low")!
        case .medium: return UIImage(named: "co2-medium")!
        case .high: return UIImage(named: "co2-high")!
        }
    }
}

struct Product: Mappable {
    var name: String?
    var brands: [String]?
    private var _quantity: String?
    var imageUrl: String?
    var imageSmallUrl: String?
    var frontImageUrl: String?
    var frontImageSmallUrl: String?
    var barcode: String?
    var packaging: [String]?
    var categories: [String]?
    var categoriesTags: [String]?
    var nutriscore: String?
    var novaGroup: String?
    var manufacturingPlaces: String?
    var origins: String?
    var labels: [String]?
    var citiesTags: [String]?
    var embCodesTags: [String]?
    var stores: [String]?
    var countries: [String]?
    var ingredientsImageUrl: String?
    var ingredientsList: String?
    var allergens: [Tag]?
    var traces: String?
    var additives: [Tag]?
    var palmOilIngredients: [String]?
    var possiblePalmOilIngredients: [String]?
    var servingSize: String?
    var nutritionLevels: NutritionLevels?
    var nutritionDataPer: NutritionDataPer?
    var noNutritionData: String?
    var nutriments: Nutriments?
    var nutritionTableImage: String?
    var lang: String?
    var states: [String]?
    var environmentInfoCard: String?
    var environmentImpactLevelTags: [EnvironmentImpact]?

    // These are not in any json response, but we will use them internally for all products we create as they are easier to work with
    var quantity: String? {
        get {
            if _quantity == nil, let quantityValue = quantityValue, !quantityValue.isEmpty, let quantityUnit = quantityUnit, !quantityUnit.isEmpty {
                return "\(quantityValue) \(quantityUnit)"
            } else if let quantity = _quantity {
                return quantity
            } else {
                return nil
            }
        }
        set {
            _quantity = newValue
        }
    }
    var quantityValue: String?
    var quantityUnit: String?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name <- map[OFFJson.ProductNameKey]
        brands <- (map[OFFJson.BrandsKey], ArrayTransform())
        _quantity <- map[OFFJson.QuantityKey]
        frontImageUrl <- map[OFFJson.ImageFrontUrlKey]
        frontImageSmallUrl <- map[OFFJson.ImageFrontSmallUrlKey]
        imageUrl <- map[OFFJson.ImageUrlKey]
        imageSmallUrl <- map[OFFJson.ImageSmallUrlKey]
        barcode <- map[OFFJson.CodeKey]
        packaging <- (map[OFFJson.PackagingKey], ArrayTransform())
        categories <- (map[OFFJson.CategoriesKey], ArrayTransform())
        categoriesTags <- (map[OFFJson.CategoriesTagsKey])
        nutriscore <- map[OFFJson.NutritionGradesKey]
        novaGroup <- map[OFFJson.NovaGroupKey]
        manufacturingPlaces <- map[OFFJson.ManufacturingPlacesKey]
        origins <- map[OFFJson.OriginsKey]
        labels <- (map[OFFJson.LabelsKey], ArrayTransform())
        citiesTags <- map[OFFJson.CitiesTagsKey]
        embCodesTags <- map[OFFJson.EmbCodesTagsKey]
        stores <- (map[OFFJson.StoresKey], ArrayTransform())
        countries <- (map[OFFJson.CountriesKey], ArrayTransform())
        ingredientsImageUrl <- map[OFFJson.ImageIngredientsUrlKey]
        ingredientsList <- map[OFFJson.IngredientsKey]
        allergens <- (map[OFFJson.AllergensTagsKey], TagTransform())
        traces <- map[OFFJson.TracesKey]
        additives <- (map[OFFJson.AdditivesTagsKey], TagTransform())
        palmOilIngredients <- map[OFFJson.IngredientsFromPalmOilTagsKey]
        possiblePalmOilIngredients <- map[OFFJson.IngredientsThatMayBeFromPalmOilTagsKey]
        servingSize <- map[OFFJson.ServingSizeKey]
        noNutritionData <- map[OFFJson.NoNutritionDataKey]
        nutritionLevels <- map[OFFJson.NutrientLevelsKey]
        nutriments <- map[OFFJson.NutrimentsKey]
        nutritionDataPer <- map[OFFJson.NutritionDataPerKey]
        nutritionTableImage <- map[OFFJson.ImageNutritionUrlKey]
        states <- (map[OFFJson.StatesKey], ArrayTransform())
        lang <- map[OFFJson.LangKey]
        environmentInfoCard <- map[OFFJson.EnvironmentInfoCardKey]
        environmentImpactLevelTags <- map[OFFJson.EnvironmentImpactLevelTagsKey]
    }
}
