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
    var fats: [NutrimentItem]
    var carbohydrates: [NutrimentItem]
    var fiber: NutrimentItem?
    var proteins: [NutrimentItem]
    var salt: NutrimentItem?
    var sodium: NutrimentItem?
    var alcohol: NutrimentItem?
    var vitamins: [NutrimentItem]
    var minerals: [NutrimentItem]
    var carbonFootprint: Double?
    var carbonFootprintUnit: String?

    init?(map: Map) {
        fats = [NutrimentItem]()
        carbohydrates = [NutrimentItem]()
        proteins = [NutrimentItem]()
        vitamins = [NutrimentItem]()
        minerals = [NutrimentItem]()
    }

    // swiftlint:disable function_body_length
    mutating func mapping(map: Map) {
        energy = NutrimentItem(nameKey: OFFJson.EnergyKey, map: map, localized: .energy)

        // Fats
        fats.append(NutrimentItem(nameKey: OFFJson.FatKey, map: map, localized: .fats, isMainItem: true))
        fats.append(NutrimentItem(nameKey: OFFJson.SaturatedFatKey, map: map, localized: .saturatedFats))
        fats.append(NutrimentItem(nameKey: OFFJson.MonounsaturatedFatKey, map: map, localized: .monoUnsaturatedFat))
        fats.append(NutrimentItem(nameKey: OFFJson.PolyunsaturatedFatKey, map: map, localized: .polyUnsaturatedFat))
        fats.append(NutrimentItem(nameKey: OFFJson.Omega3FatKey, map: map, localized: .omega3))
        fats.append(NutrimentItem(nameKey: OFFJson.Omega6FatKey, map: map, localized: .omega6))
        fats.append(NutrimentItem(nameKey: OFFJson.Omega9FatKey, map: map, localized: .omega9))
        fats.append(NutrimentItem(nameKey: OFFJson.TransFatKey, map: map, localized: .transFat))
        fats.append(NutrimentItem(nameKey: OFFJson.CholesterolKey, map: map, localized: .cholesterol))

        // Carbohydrates
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.CarbohydratesKey, map: map, localized: .carbohydrates, isMainItem: true))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.SugarsKey, map: map, localized: .sugars))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.SucroseKey, map: map, localized: .sucrose))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.GlucoseKey, map: map, localized: .glucose))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.FructoseKey, map: map, localized: .fructose))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.LactoseKey, map: map, localized: .lactose))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.MaltoseKey, map: map, localized: .maltose))
        carbohydrates.append(NutrimentItem(nameKey: OFFJson.MaltodextrinsKey, map: map, localized: .maltodextrins))

        // Fiber
        fiber = NutrimentItem(nameKey: OFFJson.FiberKey, map: map, localized: .fiber)

        // Protein
        proteins.append(NutrimentItem(nameKey: OFFJson.ProteinsKey, map: map, localized: .proteins, isMainItem: true))
        proteins.append(NutrimentItem(nameKey: OFFJson.CaseinKey, map: map, localized: .casein))
        proteins.append(NutrimentItem(nameKey: OFFJson.SerumProteinsKey, map: map, localized: .serumProteins))
        proteins.append(NutrimentItem(nameKey: OFFJson.NucleotidesKey, map: map, localized: .nucleotides))

        // Salt and Alcohol
        salt = NutrimentItem(nameKey: OFFJson.SaltKey, map: map, localized: .salt)
        sodium = NutrimentItem(nameKey: OFFJson.SodiumKey, map: map, localized: .sodium)
        alcohol = NutrimentItem(nameKey: OFFJson.AlcoholKey, map: map, localized: .alcohol)

        // Vitamin
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminAKey, map: map, localized: .a, isMainItem: true))
        vitamins.append(NutrimentItem(nameKey: OFFJson.BetaCaroteneKey, map: map, localized: .betaCarotene))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminDKey, map: map, localized: .d))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminEKey, map: map, localized: .e))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminKKey, map: map, localized: .k))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminCKey, map: map, localized: .c))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminB1Key, map: map, localized: .b1))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminB2Key, map: map, localized: .b2))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminPPKey, map: map, localized: .pp))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminB6Key, map: map, localized: .b6))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminB9Key, map: map, localized: .b9))
        vitamins.append(NutrimentItem(nameKey: OFFJson.VitaminB12Key, map: map, localized: .b12))
        vitamins.append(NutrimentItem(nameKey: OFFJson.BiotinKey, map: map, localized: .biotin))
        vitamins.append(NutrimentItem(nameKey: OFFJson.PantothenicAcidKey, map: map, localized: .pantothenicAcid))

        // Minerals
        minerals.append(NutrimentItem(nameKey: OFFJson.SilicaKey, map: map, localized: .silica, isMainItem: true))
        minerals.append(NutrimentItem(nameKey: OFFJson.BicarbonateKey, map: map, localized: .bicarbonate))
        minerals.append(NutrimentItem(nameKey: OFFJson.PotassiumKey, map: map, localized: .potassium))
        minerals.append(NutrimentItem(nameKey: OFFJson.ChlorideKey, map: map, localized: .chloride))
        minerals.append(NutrimentItem(nameKey: OFFJson.CalciumKey, map: map, localized: .calcium))
        minerals.append(NutrimentItem(nameKey: OFFJson.PhosphorusKey, map: map, localized: .phosphorus))
        minerals.append(NutrimentItem(nameKey: OFFJson.IronKey, map: map, localized: .iron))
        minerals.append(NutrimentItem(nameKey: OFFJson.MagnesiumKey, map: map, localized: .magnesium))
        minerals.append(NutrimentItem(nameKey: OFFJson.ZincKey, map: map, localized: .zinc))
        minerals.append(NutrimentItem(nameKey: OFFJson.CopperKey, map: map, localized: .copper))
        minerals.append(NutrimentItem(nameKey: OFFJson.ManganeseKey, map: map, localized: .manganese))
        minerals.append(NutrimentItem(nameKey: OFFJson.FluorideKey, map: map, localized: .fluoride))
        minerals.append(NutrimentItem(nameKey: OFFJson.SeleniumKey, map: map, localized: .selenium))
        minerals.append(NutrimentItem(nameKey: OFFJson.ChromiumKey, map: map, localized: .chromium))
        minerals.append(NutrimentItem(nameKey: OFFJson.MolybdenumKey, map: map, localized: .molybdenum))
        minerals.append(NutrimentItem(nameKey: OFFJson.IodineKey, map: map, localized: .iodine))
        minerals.append(NutrimentItem(nameKey: OFFJson.CaffeineKey, map: map, localized: .caffeine))
        minerals.append(NutrimentItem(nameKey: OFFJson.TaurineKey, map: map, localized: .taurine))
        minerals.append(NutrimentItem(nameKey: OFFJson.PhKey, map: map, localized: .ph))
        minerals.append(NutrimentItem(nameKey: OFFJson.FruitsVegetableNutsKey, map: map, localized: .fruitsVegetablesNuts))
        minerals.append(NutrimentItem(nameKey: OFFJson.CollagenMeatProteinRatio, map: map, localized: .collagenMeatProteinRatio))
        minerals.append(NutrimentItem(nameKey: OFFJson.CacaoKey, map: map, localized: .cocoa))
        minerals.append(NutrimentItem(nameKey: OFFJson.ChlorophylKey, map: map, localized: .chlorophyl))

        carbonFootprint <- (map[OFFJson.CarbonFootprint100gKey], DoubleTransform())
        carbonFootprintUnit <- map[OFFJson.CarbonFootprintUnitKey]
    }
    // swiftlint:enable function_body_length
}
