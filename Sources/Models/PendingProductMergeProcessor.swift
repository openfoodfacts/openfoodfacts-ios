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
    func merge(_ source: PendingUploadItem, _ target: Product) -> Product?
}

struct PendingProductMergeProcessor: ProductMergeProcessor {
    func merge(_ source: PendingUploadItem, _ target: Product) -> Product? {
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

        if target.quantityValue == nil, let quantityValue = source.quantityValue {
            modified = true
            result.quantityValue = quantityValue
        }

        if target.quantityUnit == nil, let quantityUnit = source.quantityUnit {
            modified = true
            result.quantityUnit = quantityUnit
        }

        if target.lang == nil {
            modified = true
            result.lang = source.language
        }

        return modified ? result : nil
    }
}
