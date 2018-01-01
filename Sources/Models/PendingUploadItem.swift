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
    var quantityValue: String?
    var quantityUnit: String?
    var language = "en"
    var frontImage: ProductImage?
    var ingredientsImage: ProductImage?
    var nutritionImage: ProductImage?

    init(barcode: String) {
        self.barcode = barcode
    }

    func toProduct() -> Product {
        var product = Product()

        product.barcode = barcode
        product.name = productName
        product.quantityValue = quantityValue
        product.quantityUnit = quantityUnit
        product.lang = language

        if let brand = self.brand {
            product.brands = [brand]
        }

        return product
    }
}
