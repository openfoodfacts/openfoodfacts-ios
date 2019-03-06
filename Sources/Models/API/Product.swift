//
//  Product.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

enum NutritionDataPer: String {
    case hundredGrams = "100g"
    case serving = "serving"
}

enum EnvironmentImpact: String {
    case low = "en-low"
    case medium = "en-medium"
    case high = "en-high"

    var image: UIImage {
        switch self {
        case .low: return UIImage(named: "co2-low")!
        case .medium: return UIImage(named: "co2-medium")!
        case .high: return UIImage(named: "co2-high")!
        }
    }
}

enum ImageTypeCategory {
    case front
    case ingredients
    case nutrition
    case general

    // These decriptions are used in the deselect/update API's to OFF
    var description: String {
        switch self {
        case .front:
            return "front"
        case .ingredients:
            return "ingredients"
        case .nutrition:
            return "nutrition"
        case .general:
            return "general"
        }
    }

    static var list: [ImageTypeCategory] {
        return [.front, .ingredients, .nutrition]
    }
}

enum ImageSizeCategory {
    case thumb
    case small
    case display
    case unknown
    
    var description: String {
        switch self {
        case .thumb:
            return "thumb"
        case .small:
            return "small"
        case .display:
            return "display"
        case .unknown:
            return "unknown"
        }
    }
}

struct Product: Mappable {
    // var name: String?
    private var nameDecoded: String?
    var brands: [String]?
    private var _quantity: String?
    var imageUrl: String?
    var imageSmallUrl: String?
    private var frontImageUrlDecoded: String?
    private var frontImageSmallUrlDecoded: String?
    var barcode: String?
    var packaging: [String]?
    var categories: [String]?
    var categoriesTags: [String]?
    var nutriscore: String?
    var novaGroup: String?
    var manufacturingPlaces: String?
    var origins: String?
    var labels: [String]?
    var citiesTags: [String]?
    var embCodesTags: [String]?
    var stores: [String]?
    var countries: [String]?
    private var ingredientsImageUrlDecoded: String?
    var allergens: [Tag]?
    var traces: String?
    var additives: [Tag]?
    var palmOilIngredients: [String]?
    var possiblePalmOilIngredients: [String]?
    var servingSize: String?
    var nutritionLevels: NutritionLevels?
    var nutritionDataPer: NutritionDataPer?
    var noNutritionData: String?
    var nutriments: Nutriments?
    private var nutritionTableImageDecoded: String?
    var lang: String?
    var states: [String]?
    var environmentInfoCard: String?
    var environmentImpactLevelTags: [EnvironmentImpact]?
    var nutritionTableHtml: String?
    // new variables for local languages
    var languageCodes: [String : Int]?
    var names: [String:String] = [:]
    var genericNames: [String:String] = [:]
    var ingredients: [String:String] = [:]
    var ingredientsListDecoded: String?
    
    private var selectedImages: [String:Any] = [:]
    private var images: [ImageTypeCategory:[ImageSizeCategory:[String:String]]] = [:]
    
    private struct KeyPreFix {
        static let ProductName = "product_name_"
        static let GenericName = "generic_name_"
        static let IngredientsText = "ingredients_text_"
        static let IngredientsTextWithAllergens = "ingredients_text_with_allergens_"
    }
    
    // These are not in any json response, but we will use them internally for all products we create as they are easier to work with
    var quantity: String? {
        get {
            if _quantity == nil, let quantityValue = quantityValue, !quantityValue.isEmpty, let quantityUnit = quantityUnit, !quantityUnit.isEmpty {
                return "\(quantityValue) \(quantityUnit)"
            } else if let quantity = _quantity {
                return quantity
            } else {
                return nil
            }
        }
        set {
            _quantity = newValue
        }
    }
    var quantityValue: String?
    var quantityUnit: String?

    var ingredientsList: String? {
        get {
            if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes),
                let ingredient = ingredients[validCode],
                !ingredient.isEmpty {
                return ingredient
            } else {
                return ingredientsListDecoded
            }
        }
        set {
            ingredientsListDecoded = newValue
        }
    }

    var name: String? {
        get {
            if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes),
                let name = names[validCode],
                !name.isEmpty {
                return name
            } else {
                return nameDecoded
            }
        }
        set {
            nameDecoded = newValue
        }
    }
    
    var frontImageUrl: String? {
        if let frontImages = images[.front] {
            if let displayFrontImages = frontImages[.display] {
                if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes) {
                    if let validImageURLString = displayFrontImages[validCode] {
                        return validImageURLString
                    }
                }
            }
        }
        return frontImageUrlDecoded
    }

    var frontImageSmallUrl: String? {
        if let frontImages = images[.front] {
            if let displayFrontImages = frontImages[.small] {
                if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes) {
                    if let validImageURLString = displayFrontImages[validCode] {
                        return validImageURLString
                    }
                }
            }
        }
        return frontImageSmallUrlDecoded
    }

    var ingredientsImageUrl: String? {
        if let ingredientsImages = images[.ingredients] {
            if let displayIngredientsImages = ingredientsImages[.display] {
                if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes) {
                    if let validImageURLString = displayIngredientsImages[validCode] {
                        return validImageURLString
                    }
                }
            }
        }
        return ingredientsImageUrlDecoded
    }

    var nutritionTableImage: String? {
        if let nutritionImages = images[.nutrition] {
            if let displayNutritionImages = nutritionImages[.display] {
                if let validCode = matchedLanguageCode(codes: Locale.preferredLanguageCodes) {
                    if let validImageURLString = displayNutritionImages[validCode] {
                        return validImageURLString
                    }
                }
            }
        }
        return nutritionTableImageDecoded
    }

    
    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        languageCodes <- map[OFFJson.LanguageCodesKey]
        nameDecoded <- map[OFFJson.ProductNameKey]
        brands <- (map[OFFJson.BrandsKey], ArrayTransform())
        _quantity <- map[OFFJson.QuantityKey]
        frontImageUrlDecoded <- map[OFFJson.ImageFrontUrlKey]
        frontImageSmallUrlDecoded <- map[OFFJson.ImageFrontSmallUrlKey]
        imageUrl <- map[OFFJson.ImageUrlKey]
        imageSmallUrl <- map[OFFJson.ImageSmallUrlKey]
        barcode <- map[OFFJson.CodeKey]
        packaging <- (map[OFFJson.PackagingKey], ArrayTransform())
        categories <- (map[OFFJson.CategoriesKey], ArrayTransform())
        categoriesTags <- (map[OFFJson.CategoriesTagsKey])
        nutriscore <- map[OFFJson.NutritionGradesKey]
        novaGroup <- map[OFFJson.NovaGroupKey]
        manufacturingPlaces <- map[OFFJson.ManufacturingPlacesKey]
        origins <- map[OFFJson.OriginsKey]
        labels <- (map[OFFJson.LabelsKey], ArrayTransform())
        citiesTags <- map[OFFJson.CitiesTagsKey]
        embCodesTags <- map[OFFJson.EmbCodesTagsKey]
        stores <- (map[OFFJson.StoresKey], ArrayTransform())
        countries <- (map[OFFJson.CountriesKey], ArrayTransform())
        ingredientsImageUrlDecoded <- map[OFFJson.ImageIngredientsUrlKey]
        ingredientsListDecoded <- map[OFFJson.IngredientsKey]
        allergens <- (map[OFFJson.AllergensTagsKey], TagTransform())
        traces <- map[OFFJson.TracesKey]
        additives <- (map[OFFJson.AdditivesTagsKey], TagTransform())
        palmOilIngredients <- map[OFFJson.IngredientsFromPalmOilTagsKey]
        possiblePalmOilIngredients <- map[OFFJson.IngredientsThatMayBeFromPalmOilTagsKey]
        servingSize <- map[OFFJson.ServingSizeKey]
        noNutritionData <- map[OFFJson.NoNutritionDataKey]
        nutritionLevels <- map[OFFJson.NutrientLevelsKey]
        nutriments <- map[OFFJson.NutrimentsKey]
        nutritionDataPer <- map[OFFJson.NutritionDataPerKey]
        nutritionTableImageDecoded <- map[OFFJson.ImageNutritionUrlKey]
        states <- (map[OFFJson.StatesKey], ArrayTransform())
        lang <- map[OFFJson.LangKey]
        environmentInfoCard <- map[OFFJson.EnvironmentInfoCardKey]
        environmentImpactLevelTags <- map[OFFJson.EnvironmentImpactLevelTagsKey]
        nutritionTableHtml <- map[OFFJson.NutritionTableHtml]

        // try to extract all language specific fields

        // guard let validLanguageCodes = languageCodes else { return }

        for languageCode in Locale.preferredLanguageCodes {

            names[languageCode] <- map[OFFJson.ProductNameKey + OFFJson.KeySeparator + languageCode]
            genericNames[languageCode] <- map[OFFJson.GenericNameKey + OFFJson.KeySeparator + languageCode]
            ingredients[languageCode] <- map[OFFJson.IngredientsTextKey + OFFJson.KeySeparator + languageCode]
        }
    }

    func matchedLanguageCode(codes:[String]) -> String? {
        guard let validLanguageCodes = languageCodes else { return nil }
        for code in codes {
            if validLanguageCodes[code] != nil {
                return code
            }
        }
        return lang
    }

    private mutating func decodeImages(_ selectedImages: [String:Any]) {
        for imageTypes in selectedImages {
            if let validImages = decodeTypes(imageTypes.key, value: imageTypes.value, for: .front) {
                images[.front] = [validImages.0: validImages.1]
            }
            if let validImages = decodeTypes(imageTypes.key, value: imageTypes.value, for: .ingredients) {
                images[.ingredients] = [validImages.0: validImages.1]
            }
            if let validImages = decodeTypes(imageTypes.key, value: imageTypes.value, for: .nutrition) {
                images[.nutrition] = [validImages.0: validImages.1]
            }
        }
    }

    private func decodeTypes(_ key: String, value: Any, for sizeCategory: ImageTypeCategory) -> (ImageSizeCategory, [String:String])? {
        var imageSizes: (ImageSizeCategory, [String:String])? = nil
        if key == sizeCategory.description {
            if let imageTypesSizes = value as? [String:Any] {
                for imageTypeSize in imageTypesSizes {
                    var image = decodeTypeSizes(imageTypeSize.key, value: imageTypeSize.value, for: .display)
                    if let validImage = image {
                        imageSizes = (.display, [validImage.0:validImage.1])
                    }
                    image = decodeTypeSizes(imageTypeSize.key, value: imageTypeSize.value, for: .small)
                    if let validImage = image {
                        imageSizes = (.small, [validImage.0:validImage.1])
                    }

                    image = decodeTypeSizes(imageTypeSize.key, value: imageTypeSize.value, for: .thumb)
                    if let validImage = image {
                        imageSizes = (.thumb, [validImage.0:validImage.1])
                    }

                }
            }
        }
        return imageSizes
    }

    private func decodeTypeSizes(_ key: String, value: Any, for sizeCategory: ImageSizeCategory) -> (String, String)? {
        var image: (String,String)? = nil
        if key == sizeCategory.description {
            if let imageTypeSizeSet = value as? [String:String] {
                for languageImage in imageTypeSizeSet {
                    image = (languageImage.key, languageImage.value)
                }
            }
        }
        return image
    }

}

extension Locale {

    static var interfaceLanguageCode:String {
        return Locale.preferredLanguages[0].split(separator:"-").map(String.init)[0]
    }

    static var countryCode:String {
        return Locale.current.identifier.split(separator:"_").map(String.init)[1]
    }

    static var preferredLanguageCodes:[String] {
        return Locale.preferredLanguages[0].split(separator:"-").map(String.init)

    }

    static var preferredLanguageCode: String {
        return Locale.preferredLanguageCodes[0]
    }

}
