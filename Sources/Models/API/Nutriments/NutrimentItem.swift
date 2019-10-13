//
//  NutrimentItem.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

struct NutrimentItem {
    var total: Double?
    var per100g: Double?
    var perServing: Double?
    var unit: String?
    var modifier: String?
    var value: Double?
    var isMainItem: Bool // Whether this item is the main item in a group, used to hightlight. Like Fat in the Fats group.

    // Json keys
    let nameKey: String

    let localized: InfoRowKey

    var nutritionTableRow: NutritionTableRow? {
        guard let per100g = self.per100g else { return nil }
        guard let unit = self.unit else { return nil }

        var perServingValue: String?
        if let perServing = perServing {
            perServingValue = "\(perServing.asTwoDecimalRoundedString) \(unit)"
        }

        return NutritionTableRow(label: localized.localizedString, perSizeValue: "\(per100g.asTwoDecimalRoundedString) \(unit)", perServingValue: perServingValue, highlight: isMainItem)
    }

    init?(nameKey: String, map: Map, localized: InfoRowKey, isMainItem mainItem: Bool = false) {
        self.nameKey = nameKey

        self.total <- (map[nameKey], DoubleTransform())
        self.per100g <- (map["\(nameKey)_100g"], DoubleTransform())
        self.perServing <- (map["\(nameKey)_serving"], DoubleTransform())
        self.unit <- map["\(nameKey)_unit"]
        self.modifier <- map["\(nameKey)_modifier"]
        self.value <- (map["\(nameKey)_value"], DoubleTransform())
        self.isMainItem = mainItem

        self.localized = localized

        // Fail init if some basic values are not present
        if self.per100g == nil && self.perServing == nil {
            return nil
        }
    }

    init?(nameKey: String, localized: InfoRowKey) {
        self.nameKey = nameKey
        self.isMainItem = false

        self.localized = localized
    }
}
