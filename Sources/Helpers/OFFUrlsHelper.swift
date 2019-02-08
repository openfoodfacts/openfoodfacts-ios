//
//  OFFurlManager.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class OFFUrlsHelper: NSObject {

    static let codeLang = Bundle.main.preferredLocalizations.first ?? "en"
    static let baseUrl = "https://world-\(codeLang).openfoodfacts.org"

    static func url(forCategory category: Category) -> URL {
        return URL(string: "\(baseUrl)/category/\(category.code)")!
    }

    static func url(forAdditive additive: Additive) -> URL {
        return URL(string: "\(baseUrl)/additive/\(additive.code)")!
    }

    static func url(forAllergen allergen: Allergen) -> URL {
        return URL(string: "\(baseUrl)/allergen/\(allergen.code)")!
    }

    static func url(forEmbCodeTag tag: String) -> URL {
        return URL(string: "\(baseUrl)/packager-code/\(tag)")!
    }
}
