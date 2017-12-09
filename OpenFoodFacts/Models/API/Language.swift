//
//  Language.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 08/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

struct Language {
    let code: String
    let name: String
}

extension Language: Equatable {
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code && lhs.name == rhs.name
    }
}

extension Language: Pickable {
    var rowTitle: String {
        return self.name
    }
}
