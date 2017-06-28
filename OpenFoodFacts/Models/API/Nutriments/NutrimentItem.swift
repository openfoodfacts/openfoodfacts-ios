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
    var value: Double?
    var isMainItem: Bool // Whether this item is the main item in a group, used to hightlight. Like Fat in the Fats group.
    
    // Json keys
    let nameKey: String
    let per100gKey: String
    let servingKey: String
    let unitKey: String
    let valueKey: String
    
    let localized: InfoRowKey
    
    var asInfoRow: InfoRow? {
        guard let per100g = self.per100g else { return nil }
        guard let perServing = self.perServing else { return nil }
        guard let unit = self.unit else { return nil }
        return InfoRow(label: localized, value: "\(per100g.asTwoDecimalRoundedString) \(unit)",secondaryValue: "\(perServing.asTwoDecimalRoundedString) \(unit)", highlight: isMainItem)
    }
    
    init(nameKey: String, map: Map, localized: InfoRowKey, isMainItem mainItem: Bool = false) {
        self.nameKey = nameKey
        self.per100gKey = "\(nameKey)_100g"
        self.servingKey = "\(nameKey)_serving"
        self.unitKey = "\(nameKey)_unit"
        self.valueKey = "\(nameKey)_value"
        
        self.total <- (map[nameKey], DoubleTransform())
        self.per100g <- (map[per100gKey], DoubleTransform())
        self.perServing <- (map[servingKey], DoubleTransform())
        self.unit <- map[unitKey]
        self.value <- (map[valueKey], DoubleTransform())
        self.isMainItem = mainItem
        
        self.localized = localized
    }
}
