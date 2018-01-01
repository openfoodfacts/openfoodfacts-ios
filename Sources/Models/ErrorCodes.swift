//
//  ErrorCodes.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct Errors {
    static let domain = "OpenFoodFactsErrorDomain"

    // swiftlint:disable:next type_name
    enum codes: Int {
        case generic = 1
        case wrongCredentials = 2
    }
}
