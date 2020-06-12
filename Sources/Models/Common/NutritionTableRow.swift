//
//  NutritionTableRow.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct NutritionTableRow {
    let label: String
    let perSizeValue: String
    let perServingValue: String?
    let highlight: Bool

    init(label: String, perSizeValue: String, perServingValue: String? = nil, highlight: Bool = false) {
        self.label = label
        self.perSizeValue = perSizeValue
        self.perServingValue = perServingValue
        self.highlight = highlight
    }

}

struct NutritionScoreTableRow {
    weak var delegate: NutritionHeaderTableViewCellDelegate?
    let nutriscore: String?
    let noFiberWarning: Bool
    let noFruitsVegetablesNutsWarning: Bool

    init(_ delegate: NutritionHeaderTableViewCellDelegate?, nutriscore: String?, noFiberWarning: Bool, noFruitsVegetablesNutsWarning: Bool) {
        self.delegate = delegate
        self.nutriscore = nutriscore
        self.noFiberWarning = noFiberWarning
        self.noFruitsVegetablesNutsWarning = noFruitsVegetablesNutsWarning
    }
}
