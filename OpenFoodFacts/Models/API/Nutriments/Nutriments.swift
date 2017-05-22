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
    var energy: NutrimentItem?
    var fats: Fats
    var carbohydrates: Carbohydrates
    var fiber: NutrimentItem?
    var proteins: Proteins
    var salt: NutrimentItem?
    var sodium: NutrimentItem?
    var alcohol: NutrimentItem?
    var vitamins: Vitamins
    var minerals: Minerals
    var carbonFootprint: Double?
    var carbonFootprintUnit: String?
    
    init?(map: Map) {
        fats = Fats()
        carbohydrates = Carbohydrates()
        proteins = Proteins()
        vitamins = Vitamins()
        minerals = Minerals()
    }
    
    mutating func mapping(map: Map) {
        energy = NutrimentItem(nameKey: OFFJson.EnergyKey, map: map, localized: .energy)
        
        // Fats
        fats.fat = NutrimentItem(nameKey: OFFJson.FatKey, map: map, localized: .fats)
        fats.saturatedFat = NutrimentItem(nameKey: OFFJson.SaturatedFatKey, map: map, localized: .saturatedFats)
        fats.monoUnsaturatedFat = NutrimentItem(nameKey: OFFJson.MonounsaturatedFatKey, map: map, localized: .monoUnsaturatedFat)
        fats.polyUnsaturatedFat = NutrimentItem(nameKey: OFFJson.PolyunsaturatedFatKey, map: map, localized: .polyUnsaturatedFat)
        fats.omega3 = NutrimentItem(nameKey: OFFJson.Omega3FatKey, map: map, localized: .omega3)
        fats.omega6 = NutrimentItem(nameKey: OFFJson.Omega6FatKey, map: map, localized: .omega6)
        fats.omega9 = NutrimentItem(nameKey: OFFJson.Omega9FatKey, map: map, localized: .omega9)
        fats.transFat = NutrimentItem(nameKey: OFFJson.TransFatKey, map: map, localized: .transFat)
        fats.cholesterol = NutrimentItem(nameKey: OFFJson.CholesterolKey, map: map, localized: .cholesterol)
        
        // Carbohydrates
        carbohydrates.carbohydrates = NutrimentItem(nameKey: OFFJson.CarbohydratesKey, map: map, localized: .carbohydrates)
        carbohydrates.sugars = NutrimentItem(nameKey: OFFJson.SugarsKey, map: map, localized: .sugars)
        carbohydrates.sucrose = NutrimentItem(nameKey: OFFJson.SucroseKey, map: map, localized: .sucrose)
        carbohydrates.glucose = NutrimentItem(nameKey: OFFJson.GlucoseKey, map: map, localized: .glucose)
        carbohydrates.fructose = NutrimentItem(nameKey: OFFJson.FructoseKey, map: map, localized: .fructose)
        carbohydrates.lactose = NutrimentItem(nameKey: OFFJson.LactoseKey, map: map, localized: .lactose)
        carbohydrates.maltose = NutrimentItem(nameKey: OFFJson.MaltoseKey, map: map, localized: .maltose)
        carbohydrates.maltodextrins = NutrimentItem(nameKey: OFFJson.MaltodextrinsKey, map: map, localized: .maltodextrins)
        
        // Fiber
        fiber = NutrimentItem(nameKey: OFFJson.FiberKey, map: map, localized: .fiber)
        
        // Protein
        proteins.proteins = NutrimentItem(nameKey: OFFJson.ProteinsKey, map: map, localized: .proteins)
        proteins.casein = NutrimentItem(nameKey: OFFJson.CaseinKey, map: map, localized: .casein)
        proteins.serumProteins = NutrimentItem(nameKey: OFFJson.SerumProteinsKey, map: map, localized: .serumProteins)
        proteins.nucleotides = NutrimentItem(nameKey: OFFJson.NucleotidesKey, map: map, localized: .nucleotides)
        
        // Salt and Alcohol
        salt = NutrimentItem(nameKey: OFFJson.SaltKey, map: map, localized: .salt)
        sodium = NutrimentItem(nameKey: OFFJson.SodiumKey, map: map, localized: .sodium)
        alcohol = NutrimentItem(nameKey: OFFJson.AlcoholKey, map: map, localized: .alcohol)
        
        // Vitamin
        vitamins.a = NutrimentItem(nameKey: OFFJson.VitaminAKey, map: map, localized: .a)
        vitamins.betaCarotene = NutrimentItem(nameKey: OFFJson.BetaCaroteneKey, map: map, localized: .betaCarotene)
        vitamins.d = NutrimentItem(nameKey: OFFJson.VitaminDKey, map: map, localized: .d)
        vitamins.e = NutrimentItem(nameKey: OFFJson.VitaminEKey, map: map, localized: .e)
        vitamins.k = NutrimentItem(nameKey: OFFJson.VitaminKKey, map: map, localized: .k)
        vitamins.c = NutrimentItem(nameKey: OFFJson.VitaminCKey, map: map, localized: .c)
        vitamins.b1 = NutrimentItem(nameKey: OFFJson.VitaminB1Key, map: map, localized: .b1)
        vitamins.b2 = NutrimentItem(nameKey: OFFJson.VitaminB2Key, map: map, localized: .b2)
        vitamins.pp = NutrimentItem(nameKey: OFFJson.VitaminPPKey, map: map, localized: .pp)
        vitamins.b6 = NutrimentItem(nameKey: OFFJson.VitaminB6Key, map: map, localized: .b6)
        vitamins.b9 = NutrimentItem(nameKey: OFFJson.VitaminB9Key, map: map, localized: .b9)
        vitamins.b12 = NutrimentItem(nameKey: OFFJson.VitaminB12Key, map: map, localized: .b12)
        vitamins.biotin = NutrimentItem(nameKey: OFFJson.BiotinKey, map: map, localized: .biotin)
        vitamins.pantothenicAcid = NutrimentItem(nameKey: OFFJson.PantothenicAcidKey, map: map, localized: .pantothenicAcid)
        
        // Minerals
        minerals.silica = NutrimentItem(nameKey: OFFJson.SilicaKey, map: map, localized: .silica)
        minerals.bicarbonate = NutrimentItem(nameKey: OFFJson.BicarbonateKey, map: map, localized: .bicarbonate)
        minerals.potassium = NutrimentItem(nameKey: OFFJson.PotassiumKey, map: map, localized: .potassium)
        minerals.chloride = NutrimentItem(nameKey: OFFJson.ChlorideKey, map: map, localized: .chloride)
        minerals.calcium = NutrimentItem(nameKey: OFFJson.CalciumKey, map: map, localized: .calcium)
        minerals.phosphorus = NutrimentItem(nameKey: OFFJson.PhosphorusKey, map: map, localized: .phosphorus)
        minerals.iron = NutrimentItem(nameKey: OFFJson.IronKey, map: map, localized: .iron)
        minerals.magnesium = NutrimentItem(nameKey: OFFJson.MagnesiumKey, map: map, localized: .magnesium)
        minerals.zinc = NutrimentItem(nameKey: OFFJson.ZincKey, map: map, localized: .zinc)
        minerals.copper = NutrimentItem(nameKey: OFFJson.CopperKey, map: map, localized: .copper)
        minerals.manganese = NutrimentItem(nameKey: OFFJson.ManganeseKey, map: map, localized: .manganese)
        minerals.fluoride = NutrimentItem(nameKey: OFFJson.FluorideKey, map: map, localized: .fluoride)
        minerals.selenium = NutrimentItem(nameKey: OFFJson.SeleniumKey, map: map, localized: .selenium)
        minerals.chromium = NutrimentItem(nameKey: OFFJson.ChromiumKey, map: map, localized: .chromium)
        minerals.molybdenum = NutrimentItem(nameKey: OFFJson.MolybdenumKey, map: map, localized: .molybdenum)
        minerals.iodine = NutrimentItem(nameKey: OFFJson.IodineKey, map: map, localized: .iodine)
        minerals.caffeine = NutrimentItem(nameKey: OFFJson.CaffeineKey, map: map, localized: .caffeine)
        minerals.taurine = NutrimentItem(nameKey: OFFJson.TaurineKey, map: map, localized: .taurine)
        minerals.ph = NutrimentItem(nameKey: OFFJson.PhKey, map: map, localized: .ph)
        minerals.fruitsVegetablesNuts = NutrimentItem(nameKey: OFFJson.FruitsVegetableNutsKey, map: map, localized: .fruitsVegetablesNuts)
        minerals.collagenMeatProteinRatio = NutrimentItem(nameKey: OFFJson.CollagenMeatProteinRatio, map: map, localized: .collagenMeatProteinRatio)
        minerals.cocoa = NutrimentItem(nameKey: OFFJson.CacaoKey, map: map, localized: .cocoa)
        minerals.chlorophyl = NutrimentItem(nameKey: OFFJson.ChlorophylKey, map: map, localized: .chlorophyl)
        
        carbonFootprint <- (map[OFFJson.CarbonFootprint100gKey], DoubleTransform())
        carbonFootprintUnit <- map[OFFJson.CarbonFootprintUnitKey]
    }
}
