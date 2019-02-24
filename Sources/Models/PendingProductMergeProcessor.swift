//
//  PendingProductMergeProcessor.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 29/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

protocol ProductMergeProcessor {
    /// Merge data in the source object into the target object
    ///
    /// - Parameters:
    ///   - source: Source object
    ///   - target: Destination object
    /// - Returns: Destination object with source's info
    func merge(_ source: PendingUploadItem, _ target: Product) -> (product: Product?, nutriments: [RealmPendingUploadNutrimentItem]?)
}

struct PendingProductMergeProcessor: ProductMergeProcessor {
    func merge(_ source: PendingUploadItem, _ target: Product) -> (product: Product?, nutriments: [RealmPendingUploadNutrimentItem]?) {
        var result = Product()
        var modified = false

        result.barcode = source.barcode

        if target.name == nil, let name = source.productName {
            modified = true
            result.name = name
        }

        if target.brands == nil, let brand = source.brand {
            modified = true
            result.brands = [brand]
        }

        if target.quantity == nil, let quantity = source.quantity {
            modified = true
            result.quantity = quantity
        }

        if target.noNutritionData == nil, let noNutritionData = source.noNutritionData {
            modified = true
            result.noNutritionData = noNutritionData
        }
        if target.servingSize == nil, let servingSize = source.servingSize {
            modified = true
            result.servingSize = servingSize
        }
        if target.nutritionDataPer == nil, let nutritionDataPer = source.nutritionDataPer {
            modified = true
            result.nutritionDataPer = NutritionDataPer(rawValue: nutritionDataPer)
        }

        if target.ingredientsList == nil, let ingredientsList = source.ingredientsList {
            modified = true
            result.ingredientsList = ingredientsList
        }

        if target.lang == nil {
            modified = true
            result.lang = source.language
        }

        var nutriments = [RealmPendingUploadNutrimentItem]()
        var nutrimentsModified = false
        if target.nutriments == nil && source.nutriments.isEmpty == false {
            nutrimentsModified = true
            nutriments = source.nutriments.map { $0 }
        }

        let productResult = (nutrimentsModified || modified) ? result : nil
        let nutrimentsResults = nutrimentsModified ? nutriments : nil

        return (productResult, nutrimentsResults)
    }
}
