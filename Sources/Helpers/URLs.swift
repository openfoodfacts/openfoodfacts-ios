//
//  URLs.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct URLs {
    static let baseUrl = "https://world\(codeLang).openfoodfacts.org"
    static let Discover = "\(baseUrl)/discover"
    static let HowToContribute = "\(baseUrl)/contribute"
    static let CreateAccount = "\(baseUrl)/cgi/user.pl"
    static let ForgotPassword = "\(baseUrl)/cgi/reset_password.pl"
    static let Edit = "\(baseUrl)/cgi/product.pl?type=edit&code="
    static let YourContributions = "\(baseUrl)/contributor/"
    static let ProductBaseURLWithLanguagePlaceholder = "\(baseUrl)/product/"
    static let OpenBeautyFacts = "itms-apps://apps.apple.com/us/app/open-beauty-facts/id1122926380"
    static let SupportOpenFoodFacts = "https://donate.openfoodfacts.org"
    static let TranslateOpenFoodFacts = "https://translate.openfoodfacts.org"
    static let FrequentlyAskedQuestions = "\(baseUrl)/faq"
    static let NutriScore = "\(baseUrl)/nutriscore"
    static let Nova = "\(baseUrl)/nova"
    static let IngredientsAnalysisIcons = "https://ssl-api.openfoodfacts.org/files/app/ingredients-analysis.json"
    static let IngredientsAnalysisIconPathPrefix = "https://static.openfoodfacts.org/images/icons/"
    static let IngredientsAnalysisIconPathSuffix = ".white.96x96.png"

    static let MockBarcode = "\(baseUrl)/files/presskit/PressKit/barcodes/"

    static let ProductBaseURL: String = {
        return ProductBaseURLWithLanguagePlaceholder.replacingOccurrences(of: "LANGUAGE", with: Locale.current.languageCode!)
    }()
//
    static var codeLang: String {
        // This is a solution for the (wrong) redirects of OFF.
        // All these links would redirect to the discover page.
        if let lang = Bundle.main.preferredLocalizations.first, lang != "en" {
            return "-" + lang
        }
        return ""
    }

    static func urlForProduct(with code: String?) -> String {
        guard let code = code else {
            return Discover
        }
        return ProductBaseURL + code
    }
}
