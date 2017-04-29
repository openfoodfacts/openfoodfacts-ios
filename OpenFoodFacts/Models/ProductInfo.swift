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
    case barcode = "product-detail.summary.barcode"
    case quantity = "product-detail.summary.quantity"
    case packaging = "product-detail.summary.packaging"
    case brands = "product-detail.summary.brands"
    case manufacturingPlaces = "product-detail.summary.manufacturingPlaces"
    case origins = "product-detail.summary.origins"
    case categories = "product-detail.summary.categories"
    case labels = "product-detail.summary.labels"
    case citiesTags = "product-detail.summary.citiesTags"
    case stores = "product-detail.summary.stores"
    case countries = "product-detail.summary.countries"
    
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
