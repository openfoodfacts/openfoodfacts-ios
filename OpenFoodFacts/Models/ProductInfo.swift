//
//  ProductInfo.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

enum ProductInfoKey: String {
    case barcode = "Barcode"
    case quantity = "Quantity"
}

struct ProductInfo {
    let label: ProductInfoKey
    let value: String
}
