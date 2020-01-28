//
//  Ingredient.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 23/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

struct Ingredient: Mappable {
    var text: String?
    var id: String?
    var rank: String?

    /// used to get dynamic ingredients properties
    var rawJson: [String: Any]?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        text <- map[OFFJson.IngredientsElementTextKey]
        id <- map[OFFJson.IngredientsElementIdKey]
        rank <- map[OFFJson.IngredientsElementRankKey]

        rawJson = map.JSON
    }
}
