//
//  ProductInfo.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct LocalizedString: ExpressibleByStringLiteral, Equatable {
    
    let v: String
    
    init(key: String) {
        self.v = NSLocalizedString(key, comment: "")
    }
    init(localized: String) {
        self.v = localized
    }
    init(stringLiteral value:String) {
        self.init(key: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(key: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(key: value)
    }
}

func ==(lhs:LocalizedString, rhs:LocalizedString) -> Bool {
    return lhs.v == rhs.v
}

enum ProductInfoKey: LocalizedString {
    case barcode = "barcode"
    case quantity = "quantity"
    case packaging = "packaging"
    case brands = "brands"
    case manufacturingPlaces = "manufacturingPlaces"
    case origins = "origins"
    case categories = "categories"
    case labels = "labels"
    case citiesTags = "citiesTags"
    case stores = "stores"
    case countries = "countries"
    
    var localizedString: String {
        return self.rawValue.v
    }
    
    init?(localizedString: String) {
        self.init(rawValue: LocalizedString(localized: localizedString))
    }
}

struct ProductInfo {
    let label: ProductInfoKey
    let value: String
}
