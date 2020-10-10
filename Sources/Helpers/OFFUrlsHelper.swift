//
//  OFFurlManager.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class OFFUrlsHelper: NSObject {

    static func codeLang() -> String {
        return Bundle.main.currentLocalization
    }

    static func baseUrl() -> String {
        return "https://world-\(codeLang()).openfoodfacts.org"
    }

    static func url(forCategory category: Category) -> URL {
        return URL(string: "\(baseUrl())/category/\(category.code)")!
    }

    static func url(for country: Country) -> URL {
        return URL(string: "\(baseUrl())/country/\(country.code)")!
    }

    static func url(forAdditive additive: Additive) -> URL {
        return URL(string: "\(baseUrl())/additive/\(additive.code)")!
    }

    static func url(forAllergen allergen: Allergen) -> URL {
        return URL(string: "\(baseUrl())/allergen/\(allergen.code)")!
    }

    static func url(forMineral mineral: Mineral) -> URL {
        return URL(string: "\(baseUrl())/mineral/\(mineral.code)")!
    }

    static func url(forVitamin vitamin: Vitamin) -> URL {
        return URL(string: "\(baseUrl())/vitamin/\(vitamin.code)")!
    }

    static func url(forNucleotide nucleotide: Nucleotide) -> URL {
        return URL(string: "\(baseUrl())/nucleotide/\(nucleotide.code)")!
    }

    static func url(forLabel label: Label) -> URL {
        return URL(string: "\(baseUrl())/label/\(label.code)")!
    }

    // Not sure if there is a taxonomy for this
    /*
     static func url(forOther other: OtherNutritionalSubstance) -> URL {
     return URL(string: "\(baseUrl)/other/\(other.code)")!
     }
     */
    static func url(forEmbCodeTag tag: String) -> URL {
        return URL(string: "\(baseUrl())/packager-code/\(tag)") ?? URL(string: "\(baseUrl())/packager-codes/") ?? URL(string: "\(baseUrl())/")!
    }
}
