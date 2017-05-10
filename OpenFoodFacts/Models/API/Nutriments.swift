//
//  Nutriments.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

struct Nutriments: Mappable {
    var fat: String?
    var fat100g: Double?
    var fatServing: String?
    var fatUnit: String?
    var fatValue: String?
    var saturatedFat: String?
    var saturatedFat100g: Double?
    var saturatedFatServing: String?
    var saturatedFatUnit: String?
    var saturatedFatValue: String?
    var sugars: String?
    var sugars100g: Double?
    var sugarsServing: String?
    var sugarsUnit: String?
    var sugarsValue: String?
    var salt: String?
    var salt100g: Double?
    var saltServing: String?
    var saltUnit: String?
    var saltValue: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        fat <- map[OFFJson.FatKey]
        fat100g <- (map[OFFJson.Fat100gKey], DoubleTransform())
        fatServing <- map[OFFJson.FatServingKey]
        fatUnit <- map[OFFJson.FatUnitKey]
        fatValue <- map[OFFJson.FatValueKey]
        saturatedFat <- map[OFFJson.SaturatedFatKey]
        saturatedFat100g <- (map[OFFJson.SaturatedFat100gKey], DoubleTransform())
        saturatedFatServing <- map[OFFJson.SaturatedFatServingKey]
        saturatedFatUnit <- map[OFFJson.SaturatedFatUnitKey]
        saturatedFatValue <- map[OFFJson.SaturatedFatValueKey]
        sugars <- map[OFFJson.SugarsKey]
        sugars100g <- (map[OFFJson.Sugars100gKey], DoubleTransform())
        sugarsServing <- map[OFFJson.SugarsServingKey]
        sugarsUnit <- map[OFFJson.SugarsUnitKey]
        sugarsValue <- map[OFFJson.SugarsValueKey]
        salt <- map[OFFJson.SaltKey]
        salt100g <- (map[OFFJson.Salt100gKey], DoubleTransform())
        saltServing <- map[OFFJson.SaltServingKey]
        saltUnit <- map[OFFJson.SaltUnitKey]
        saltValue <- map[OFFJson.SaltValueKey]
    }
}
