//
//  NutritionLevels.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

enum NutritionLevel: String {
    case Low = "low"
    case Moderate = "moderate"
    case High = "high"
}

fileprivate class NutritionLevelTransform: TransformType {
    typealias Object = NutritionLevel
    typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let level = value as? String {
            return NutritionLevel(rawValue: level)
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let level = value {
            return level.rawValue
        }
        
        return nil
    }
}

struct NutritionLevels: Mappable {
    var fat: NutritionLevel?
    var saturatedFat: NutritionLevel?
    var sugars: NutritionLevel?
    var salt: NutritionLevel?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        fat <- (map[OFFJson.NutrientLevelsFatKey], NutritionLevelTransform())
        saturatedFat <- (map[OFFJson.NutrientLevelsSaturatedFatKey], NutritionLevelTransform())
        sugars <- (map[OFFJson.NutrientLevelsSugarsKey], NutritionLevelTransform())
        salt <- (map[OFFJson.NutrientLevelsSaltKey], NutritionLevelTransform())
    }
}
