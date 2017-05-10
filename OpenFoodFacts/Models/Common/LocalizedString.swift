//
//  LocalizedString.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/05/2017.
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
