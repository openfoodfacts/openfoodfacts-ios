//
//  URLs.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct URLs {
    static let codeLang = Bundle.main.preferredLocalizations.first ?? "en"
    static let baseUrl = "https://world.openfoodfacts.org"
    static let baseLocalizedUrl = "https://world-\(codeLang).openfoodfacts.org"
    static let Discover = "\(baseLocalizedUrl)/discover"
    static let HowToContribute = "\(baseLocalizedUrl)/contribute"
    static let CreateAccount = "\(baseLocalizedUrl)/cgi/user.pl"
    static let ForgotPassword = "\(baseLocalizedUrl)/cgi/reset_password.pl"
    static let Edit = "\(baseUrl)/cgi/product.pl?type=edit&code="
    static let YourContributions = "\(baseLocalizedUrl)/contributor/"
    static let ProductBaseURLWithLanguagePlaceholder = "\(baseUrl)/product/"
    static let OpenBeautyFacts = "itms-apps://apps.apple.com/us/app/open-beauty-facts/id1122926380?mt=8"
    static let SupportOpenFoodFacts = "https://donate.openfoodfacts.org"
    static let TranslateOpenFoodFacts = "https://translate.openfoodfacts.org"
    static let FrequentlyAskedQuestions = "\(baseLocalizedUrl)/faq"

    static let MockBarcode = "\(baseUrl)/files/presskit/PressKit/barcodes/"

    static let ProductBaseURL: String = {
        return ProductBaseURLWithLanguagePlaceholder.replacingOccurrences(of: "LANGUAGE", with: Locale.current.languageCode!)
    }()
//
    static func urlForProduct(with code: String?) -> String {
        guard let code = code else {
            return Discover
        }
        return ProductBaseURL + code
    }
}
