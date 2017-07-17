//
//  LocalizedString.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct LocalizedString: ExpressibleByStringLiteral, Equatable {

    let localizedString: String

    init(key: String) {
        self.localizedString = NSLocalizedString(key, comment: "")
    }
    init(localized: String) {
        self.localizedString = localized
    }
    init(stringLiteral localizedString: String) {
        self.init(key: localizedString)
    }
    init(extendedGraphemeClusterLiteral localizedString: String) {
        self.init(key: localizedString)
    }
    init(unicodeScalarLiteral localizedString: String) {
        self.init(key: localizedString)
    }
}

func == (lhs: LocalizedString, rhs: LocalizedString) -> Bool {
    return lhs.localizedString == rhs.localizedString
}
