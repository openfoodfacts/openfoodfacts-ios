//
//  OFFReadAPIkeysJSON.swift
//  FoodViewer
//
//  Created by arnaud on 20/12/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

// JSON keys

struct OFFJson {
    // swiftlint:disable identifier_name

    static let CountKey = "count"
    static let PageKey = "page"
    static let PageSizeKey = "page_size"
    static let ProductsKey = "products"
    static let StatusKey = "status"
    static let StatusVerboseKey = "status_verbose"
    static let ProductKey = "product"
    static let CodeKey = "code"
    static let LastEditDatesTagsKey = "last_edit_dates_tags"
    static let LabelsHierarchyKey = "labels_hierarchy"
    static let ImageFrontSmallUrlKey = "image_front_small_url"
    static let IIdKey = "_id"
    static let LabelsDebugTagsKey = "labels_debug_tags"
    static let CategoriesHierarchyKey = "categories_hierarchy"
    static let PnnsGroups1Key = "pnns_groups_1"
    static let StatesTagsKey = "states_tags"
    static let CheckersTagsKey = "checkers_tags"
    static let LabelsTagsKey = "labels_tags"
    static let ProductCodeKey = "code"
    static let AdditivesTagsNKey = "additives_tags_n"
    static let TracesTagsKey = "traces_tags"
    static let LangKey = "lang"
    static let DebugParamSortedLangsKey = "debug_param_sorted_langs"
    static let LanguagesHierarchyKey = "languages_hierarchy"
    static let PhotographersKey = "photographers"
    static let GenericNameKey = "generic_name"
    static let IngredientsThatMayBeFromPalmOilTagsKey = "ingredients_that_may_be_from_palm_oil_tags"
    static let AdditivesPrevNKey = "additives_prev_n"
    static let KeywordsKey = "_keywords"
    static let RevKey = "rev"
    // added for decoding of languages
                            static let LanguageCodesKey = "languages_codes"
    static let EditorsKey = "editors"
    static let InterfaceVersionCreatedKey = "interface_version_created"
    static let EmbCodesKey = "emb_codes"
    static let MaxImgidKey = "max_imgid"
    static let AdditivesTagsKey = "additives_tags"
    static let EmbCodesOrigKey = "emb_codes_orig"
    static let InformersTagsKey = "informers_tags"
    static let NutrientLevelsTagsKey = "nutrient_levels_tags"
    static let PhotographersTagsKey = "photographers_tags"
    static let AdditivesNKey = "additives_n"
    static let PnnsGroups2TagsKey = "pnns_groups_2_tags"
    static let UnknownNutrientsTagsKey = "unknown_nutrients_tags"
    static let CategoriesPrevTagsKey = "categories_prev_tags"
    static let PackagingTagsKey = "packaging_tags"
    static let ManufacturingPlacesKey = "manufacturing_places"
    static let LinkKey = "link"
    static let IngredientsNKey = "ingredients_n"
    static let NutrimentsKey = "nutriments"
    static let SodiumKey = "sodium"
    static let SaltKey = "salt"
    static let Salt100gKey = "salt_100g"
    static let SaltServingKey = "salt_serving"
    static let SaltUnitKey = "salt_unit"
    static let SaltValueKey = "salt_value"
    static let SugarsKey = "sugars"
    static let Sugars100gKey = "sugars_100g"
    static let SugarsServingKey = "sugars_serving"
    static let SugarsUnitKey = "sugars_unit"
    static let SugarsValueKey = "sugars_value"
    static let EnergyKey = "energy"
    static let ProteinsKey = "proteins"
    static let CaseinKey = "casein"
    static let SerumProteinsKey = "serum-proteins"
    static let NucleotidesKey = "nucleotides"
    static let CarbohydratesKey = "carbohydrates"
    static let SucroseKey = "sucrose"
    static let GlucoseKey = "glucose"
    static let FructoseKey = "fructose"
    static let LactoseKey = "lactose"
    static let MaltoseKey = "maltose"
    static let MaltodextrinsKey = "maltodextrins"
    static let StarchKey = "starch"
    static let PolyolsKey = "polyols"
    static let FatKey = "fat"
    static let SaturatedFatKey = "saturated-fat"
    static let ButyricAcidKey = "butyric-acid"
    static let CaproicAcidKey = "caproic-acid"
    static let CaprylicAcidKey = "caprylic-acid"
    static let CapricAcidKey = "capric-acid"
    static let LauricAcidKey = "lauric-acid"
    static let MyristicAcidKey = "myristic-acid"
    static let PalmiticAcidKey = "palmitic-acid"
    static let StearicAcidKey = "stearic-acid"
    static let ArachidicAcidKey = "arachidic-acid"
    static let BehenicAcidKey = "behenic-acid"
    static let LignocericAcidKey = "lignoceric-acid"
    static let CeroticAcidKey = "cerotic-acid"
    static let MontanicAcidKey = "montanic-acid"
    static let MelissicAcidKey = "melissic-acid"
    static let MonounsaturatedFatKey = "monounsaturated-fat"
    static let PolyunsaturatedFatKey = "polyunsaturated-fat"
    static let Omega3FatKey = "omega-3-fat"
    static let AlphaLinolenicAcidKey = "alpha-linolenic-acid"
    static let EicosapentaenoicAcidKey = "eicosapentaenoic-acid"
    static let DocosahexaenoicAcidKey = "docosahexaenoic-acid"
    static let Omega6FatKey = "omega-6-fat"
    static let LinoleicAcidKey = "linoleic-acid"
    static let ArachidonicAcidKey = "arachidonic-acid"
    static let GammaLinolenicAcidKey = "gamma-linolenic-acid"
    static let DihomoGammaLinolenicAcidKey = "dihomo-gamma-linolenic-acid"
    static let Omega9FatKey = "omega-9-fat"
    static let VoleicAcidKey = "voleic-acid"
    static let ElaidicAcidKey = "elaidic-acid"
    static let GondoicAcidKey = "gondoic-acid"
    static let MeadAcidKey = "mead-acid"
    static let ErucicAcidKey = "erucic-acid"
    static let NervonicAcidKey = "nervonic-acid"
    static let TransFatKey = "trans-fat"
    static let CholesterolKey = "cholesterol"
    static let FiberKey = "fiber"
    static let AlcoholKey = "alcohol"
    static let VitaminAKey = "vitamin-a"
    static let BetaCaroteneKey = "beta-carotene"
    static let VitaminDKey = "vitamin-d"
    static let VitaminEKey = "vitamin-e"
    static let VitaminKKey = "vitamin-k"
    static let VitaminCKey = "vitamin-c"
    static let VitaminB1Key = "vitamin-b1"
    static let VitaminB2Key = "vitamin-b2"
    static let VitaminPPKey = "vitamin-pp"
    static let VitaminB6Key = "vitamin-b6"
    static let VitaminB9Key = "vitamin-b9"
    static let VitaminB12Key = "vitamin-b12"
    static let BiotinKey = "biotin"
    static let PantothenicAcidKey = "pantothenic-acid"
    static let SilicaKey = "silica"
    static let BicarbonateKey = "bicarbonate"
    static let PotassiumKey = "potassium"
    static let ChlorideKey = "chloride"
    static let CalciumKey = "calcium"
    static let PhosphorusKey = "phosphorus"
    static let IronKey = "iron"
    static let MagnesiumKey = "magnesium"
    static let ZincKey = "zinc"
    static let CopperKey = "copper"
    static let ManganeseKey = "manganese"
    static let FluorideKey = "fluoride"
    static let SeleniumKey = "selenium"
    static let ChromiumKey = "chromium"
    static let MolybdenumKey = "molybdenum"
    static let IodineKey = "iodine"
    static let CaffeineKey = "caffeine"
    static let TaurineKey = "taurine"
    static let PhKey = "ph"
    static let FruitsVegetableNutsKey = "fruits-vegetables-nuts"
    static let CollagenMeatProteinRatio = "collagen-meat-protein-ratio"
    static let CacaoKey = "cocoa"
    static let ChlorophylKey = "chlorophyl"
    static let CarbonFootprint100gKey = "carbon-footprint_100g"
    static let CarbonFootprintUnitKey = "carbon-footprint_unit"
    //static let CarbohydratesUnitKey = "carbohydrates_unit"
    //static let FatUnitKey = "fat_unit"
    static let NutritionScoreFr100gKey = "nutrition-score-fr_100g"
    //static let SodiumServingKey = "sodium_serving"
    //static let ProteinsKey = "proteins"
    //static let ProteinsServingKey = "proteins_serving"
    //static let Proteins100gKey = "proteins_100g"
    //static let ProteinsUnitKey = "proteins_unit"
    static let NutritionScoreFrKey = "nutrition-score-fr"
    static let NutritionScoreUk100gKey = "nutrition-score-uk_100g"
    static let CountriesTagsKey = "countries_tags"
    static let IngredientsFromPalmOilTagsKey = "ingredients_from_palm_oil_tags"
    static let EmbCodesTagsKey = "emb_codes_tags"
    static let BrandsTagsKey = "brands_tags"
    static let PurchasePlacesKey = "purchase_places"
    static let PnnsGroups2Key = "pnns_groups_2"
    static let CountriesHierarchyKey = "countries_hierarchy"
    static let TracesKey = "traces"
    static let AdditivesOldTagsKey = "additives_old_tags"
    static let ImageNutritionUrlKey = "image_nutrition_url"
    static let CategoriesKey = "categories"
    static let IngredientsTextDebugKey = "ingredients_text_debug"
    static let IngredientsTextKey = "ingredients_text"
    static let EditorsTagsKey = "editors_tags"
    static let LabelsPrevTagsKey = "labels_prev_tags"
    static let AdditivesOldNKey = "additives_old_n"
    static let CategoriesPrevHierarchyKey = "categories_prev_hierarchy"
    static let CreatedTKey = "created_t"
    static let ProductNameKey = "product_name"
    static let IngredientsFromOrThatMayBeFromPalmOilNKey = "ingredients_from_or_that_may_be_from_palm_oil_n"
    static let CreatorKey = "creator"
    static let ImageFrontUrlKey = "image_front_url"
    static let NoNutritionDataKey = "no_nutrition_data" // TBD
    static let ServingSizeKey = "serving_size"
    static let CompletedTKey = "completed_t"
    static let LastModifiedByKey = "last_modified_by"
    static let NewAdditivesNKey = "new_additives_n"
    static let AdditivesPrevTagsKey = "additives_prev_tags"
    static let OriginsKey = "origins"
    static let StoresKey = "stores"
    static let NutritionGradesKey = "nutrition_grades"
    static let NutritionGradeFrKey = "nutrition_grade_fr"
    static let NovaGroupKey = "nova_group"
    static let NutrientLevelsKey = "nutrient_levels"
    static let NutrientLevelsSaltKey = "salt"
    static let NutrientLevelsFatKey = "fat"
    static let NutrientLevelsSugarsKey = "sugars"
    static let NutrientLevelsSaturatedFatKey = "saturated-fat"
    static let AdditivesPrevKey = "additives_prev"
    static let StoresTagsKey = "stores_tags"
    static let IdKey = "id"
    static let CountriesKey = "countries"
    static let ImageFrontThumbUrlKey = "image_front_thumb_url"
    static let PurchasePlacesTagsKey = "purchase_places_tags"
    static let TracesHierarchyKey = "traces_hierarchy"
    static let InterfaceVersionModifiedKey = "interface_version_modified"
    static let FruitsVegetablesNuts100gEstimateKey = "fruits-vegetables-nuts_100g_estimate"
    static let ImageThumbUrlKey = "image_thumb_url"
    static let SortkeyKey = "sortkey"
    static let ImageNutritionThumbUrlKey = "image_nutrition_thumb_url"
    static let LastModifiedTKey = "last_modified_t"
    static let ImageIngredientsUrlKey = "image_ingredients_url"
    static let NutritionScoreDebugKey = "nutrition_score_debug"
    static let ImageNutritionSmallUrlKey = "image_nutrition_small_url"
    static let CorrectorsTagsKey = "correctors_tags"
    static let CorrectorsKey = "correctors"
    static let CategoriesDebugTagsKey = "categories_debug_tags"
    static let BrandsKey = "brands"
    static let IngredientsTagsKey = "ingredients_tags"
    static let CodesTagsKey = "codes_tags"
    static let StatesKey = "states"
    static let InformersKey = "informers"
    static let EntryDatesTagsKey = "entry_dates_tags"
    static let ImageIngredientsSmallUrlKey = "image_ingredients_small_url"
    static let NutritionGradesTagsKey = "nutrition_grades_tags"
    static let PackagingKey = "packaging"
    static let ServingQuantityKey = "serving_quantity"
    static let OriginsTagsKey = "origins_tags"
    static let ManufacturingPlacesTagsKey = "manufacturing_places_tags"
    
    static let AdditivesKey = "additives"
    static let AdditivesDebugTagsKey = "additives_debug_tags"
    static let AminoAcidTagsKey = "amino_acids_tags"
    static let AllergensKey = "allergens"
    static let AllergensHierarchyKey = "allergens_hierarchy"
    static let AllergensTagsKey = "allergens_tags"
    static let CategoriesTagsKey = "categories_tags"
    static let CheckersKey = "checkers"
    static let CitiesTagsKey = "cities_tags"
    static let CompleteKey = "complete"
    static let ConservationConditionsKey = "conservation_conditions"
    static let CustomerServiceKey = "customer_service"
    static let EmbCodes20141016Key = "emb_codes_20141016"
    static let EnvironmentInfoCardKey = "environment_infocard"
    static let EnvironmentImpactLevelTagsKey = "environment_impact_level_tags"
    static let ExpirationDateKey = "expiration_date"
    static let ImageIngredientsThumbUrlKey = "image_ingredients_thumb_url"
    static let ImageSmallUrlKey = "image_small_url"
    static let ImageUrlKey = "image_url"
    static let IngredientsKey = "ingredients_text"
    static let IngredientsDebugKey = "ingredients_debug"
    static let IngredientsElementIdKey = "id"
    static let IngredientsElementRankKey = "rank"
    static let IngredientsElementTextKey = "text"
    static let IngredientsFromPalmOilNKey = "ingredients_from_palm_oil_n"
    static let IngredientsIdsDebugKey = "ingredients_ids_debug"
    static let IngredientsThatMayBeFromPalmOilNKey = "ingredients_that_may_be_from_palm_oil_n"
    static let LabelsKey = "labels"
    static let LabelsPrevHierarchyKey = "labels_prev_hierarchy"
    static let LcKey = "lc"
    static let MineralsTagsKey = "minerals_tags"
    static let NovagroupsKey = "nova_groups"
    static let NucleotidesTagsKey = "nucleotides_tags"
    static let NutritionDataPerKey = "nutrition_data_per"
    static let OtherInformationKey = "other_information"
    static let OtherNutritionalSubstancesTagsKey = "other_nutritional_substances_tags"
    static let PnnsGroups1TagsKey = "pnns_groups_1_tags"
    static let QuantityKey = "quantity"
    static let RecyclingInstructionsToDiscard = "recycling_instructions_to_discard"
    static let RecyclingInstructionsToRecycle = "recycling_instructions_to_recycle"
    static let SelectedImagesKey = "selected_images"
    static let StatesHierarchyKey = "states_hierarchy"
    static let UrlKey = "url"
    static let VitaminsTagsKey = "vitamins_tags"
    static let WarningKey = "warning"

    static let KeySeparator = "_"
    static let FieldsSeparator = ","
    // to read images in the various languages
    static let SelectedImages = "selected_images"
    // swiftlint:enable identifier_name

    static var summaryFields: [String] {
        return [
            OFFJson.BrandsKey,
            OFFJson.CodeKey,
            OFFJson.EnvironmentImpactLevelTagsKey,
            OFFJson.ImageFrontUrlKey,
            OFFJson.ImageFrontSmallUrlKey,
            OFFJson.ImageSmallUrlKey,
            OFFJson.ImageUrlKey,
            OFFJson.NovaGroupKey,
            OFFJson.NutritionGradesKey,
            OFFJson.ProductNameKey,
            OFFJson.QuantityKey]
    }

    static var allFields: [String] {
        return [
            OFFJson.AdditivesTagsKey,
            OFFJson.AllergensKey,
            OFFJson.AllergensHierarchyKey,
            OFFJson.AllergensTagsKey,
            OFFJson.AminoAcidTagsKey,
            OFFJson.BrandsKey,
            OFFJson.BrandsTagsKey,
            OFFJson.CategoriesTagsKey,
            OFFJson.CitiesTagsKey,
            OFFJson.CodeKey,
            OFFJson.ConservationConditionsKey,
            OFFJson.CountriesKey,
            OFFJson.CountriesTagsKey,
            OFFJson.CreatedTKey,
            OFFJson.CreatorKey,
            OFFJson.CustomerServiceKey,
            OFFJson.EditorsTagsKey,
            OFFJson.EmbCodesTagsKey,
            OFFJson.EnvironmentImpactLevelTagsKey,
            OFFJson.EnvironmentInfoCardKey,
            OFFJson.GenericNameKey,
            OFFJson.ImageFrontUrlKey,
            OFFJson.ImageIngredientsUrlKey,
            OFFJson.ImageNutritionUrlKey,
            OFFJson.ImageSmallUrlKey,
            OFFJson.ImageUrlKey,
            OFFJson.IngredientsFromPalmOilNKey,
            OFFJson.IngredientsFromPalmOilTagsKey,
            OFFJson.IngredientsFromOrThatMayBeFromPalmOilNKey,
            OFFJson.IngredientsTextKey,
            OFFJson.IngredientsThatMayBeFromPalmOilTagsKey,
            OFFJson.LabelsHierarchyKey,
            OFFJson.LabelsTagsKey,
            OFFJson.LangKey,
            OFFJson.LanguageCodesKey,
            OFFJson.LastModifiedByKey,
            OFFJson.LastModifiedTKey,
            OFFJson.LinkKey,
            OFFJson.ManufacturingPlacesKey,
            OFFJson.MineralsTagsKey,
            OFFJson.NoNutritionDataKey,
            OFFJson.NovaGroupKey,
            OFFJson.NovagroupsKey,
            OFFJson.NucleotidesTagsKey,
            OFFJson.NutrientLevelsKey,
            OFFJson.NutrimentsKey,
            OFFJson.NutritionDataPerKey,
            OFFJson.NutritionGradeFrKey,
            OFFJson.NutritionGradesKey,
            OFFJson.OriginsKey,
            OFFJson.OtherInformationKey,
            OFFJson.OtherNutritionalSubstancesTagsKey,
            OFFJson.PackagingKey,
            OFFJson.ProductNameKey,
            OFFJson.PurchasePlacesKey,
            OFFJson.RecyclingInstructionsToDiscard,
            OFFJson.RecyclingInstructionsToRecycle,
            OFFJson.QuantityKey,
            OFFJson.SelectedImagesKey,
            OFFJson.ServingSizeKey,
            OFFJson.StatesTagsKey,
            OFFJson.StoresKey,
            OFFJson.TracesKey,
            OFFJson.TracesTagsKey,
            OFFJson.UrlKey,
            OFFJson.VitaminsTagsKey,
            OFFJson.WarningKey
        ]
    }

    static var languageCodes: String {
        // &lc=ja,nl,de,fr,it,es
        return "&lc=" + Locale.preferredLanguageCodes.joined(separator: OFFJson.FieldsSeparator)
    }
}
