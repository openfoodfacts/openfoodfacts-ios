//
//  PendingUploadItem.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class PendingUploadItem {
    let barcode: String
    var productName: String?
    var brand: String?
    var quantity: String?
    var ingredientsList: String?
    var language = "en"
    var frontImage: ProductImage?
    var ingredientsImage: ProductImage?
    var nutritionImage: ProductImage?
    var categories: [String]?

    var noNutritionData: String?
    var servingSize: String?
    var nutritionDataPer: String?
    let nutriments = List<RealmPendingUploadNutrimentItem>()

    init(barcode: String) {
        self.barcode = barcode
    }

    func toProduct() -> Product {
        var product = Product()

        product.barcode = barcode
        product.name = productName
        product.quantity = quantity
        product.lang = language
        product.categories = categories
        product.ingredientsList = ingredientsList

        product.noNutritionData = noNutritionData
        product.servingSize = servingSize
        if let nutritionDataPer = nutritionDataPer {
            product.nutritionDataPer = NutritionDataPer(rawValue: nutritionDataPer)
        }

        if let brand = self.brand {
            product.brands = [brand]
        }

        return product
    }
}
