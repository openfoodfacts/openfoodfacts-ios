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
    case packaging = "Packaging"
    case brands = "Brands"
    case manufacturingPlaces = "Manufacturing or processing places"
    case origins = "Origin of ingredients"
    case categories = "Categories"
    case labels = "Labels, certifications, awards"
    case citiesTags = "City, state and country where purchased"
    case stores = "Stores"
    case countries = "Countries where sold"
}

struct ProductInfo {
    let label: ProductInfoKey
    let value: String
}
