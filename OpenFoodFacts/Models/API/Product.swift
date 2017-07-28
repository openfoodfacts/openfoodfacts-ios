//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

struct Product: Mappable {
    var name: String?
    var brands: [String]?
    var quantity: String?
    var imageUrl: String?
    var frontImageUrl: String?
    var barcode: String?
    var packaging: [String]?
    var categories: [String]?
    var nutriscore: String?
    var manufacturingPlaces: String?
    var origins: String?
    var labels: [String]?
    var citiesTags: String?
    var stores: [String]?
    var countries: [String]?
    var ingredientsImageUrl: String?
    var ingredientsList: String?
    var allergens: String?
    var traces: String?
    var additives: [Tag]?
    var palmOilIngredients: [String]?
    var possiblePalmOilIngredients: [String]?
    var servingSize: String?
    var nutritionLevels: NutritionLevels?
    var nutriments: Nutriments?
    var nutritionTableImage: String?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name <- map[OFFJson.ProductNameKey]
        brands <- (map[OFFJson.BrandsKey], ArrayTransform())
        quantity <- map[OFFJson.QuantityKey]
        frontImageUrl <- map[OFFJson.ImageFrontUrlKey]
        imageUrl <- map[OFFJson.ImageUrlKey]
        barcode <- map[OFFJson.CodeKey]
        packaging <- (map[OFFJson.PackagingKey], ArrayTransform())
        categories <- (map[OFFJson.CategoriesKey], ArrayTransform())
        nutriscore <- map[OFFJson.NutritionGradesKey]
        manufacturingPlaces <- map[OFFJson.ManufacturingPlacesKey]
        origins <- map[OFFJson.OriginsKey]
        labels <- (map[OFFJson.LabelsKey], ArrayTransform())
        citiesTags <- map[OFFJson.CitiesTagsKey]
        stores <- (map[OFFJson.StoresKey], ArrayTransform())
        countries <- (map[OFFJson.CountriesKey], ArrayTransform())
        ingredientsImageUrl <- map[OFFJson.ImageIngredientsUrlKey]
        ingredientsList <- map[OFFJson.IngredientsKey]
        allergens <- map[OFFJson.AllergensTagsKey]
        traces <- map[OFFJson.TracesKey]
        additives <- (map[OFFJson.AdditivesTagsKey], TagTransform())
        palmOilIngredients <- map[OFFJson.IngredientsFromPalmOilTagsKey]
        possiblePalmOilIngredients <- map[OFFJson.IngredientsThatMayBeFromPalmOilTagsKey]
        servingSize <- map[OFFJson.ServingSizeKey]
        nutritionLevels <- map[OFFJson.NutrientLevelsKey]
        nutriments <- map[OFFJson.NutrimentsKey]
        nutritionTableImage <- map[OFFJson.ImageNutritionUrlKey]
    }
}
