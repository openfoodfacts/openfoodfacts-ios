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
    static let baseUrl = "https://world-\(codeLang).openfoodfacts.org"
    
    static let Discover = "\(baseUrl)/discover"
    static let HowToContribute = "\(baseUrl)/contribute"
    static let CreateAccount = "\(baseUrl)/cgi/user.pl"
    static let ForgotPassword = "\(baseUrl)/cgi/reset_password.pl"
    static let Edit = "\(baseUrl)/cgi/product.pl?type=edit&code="
    static let YourContributions = "\(baseUrl)/contributor/"
    static let ProductBaseURLWithLanguagePlaceholder = "\(baseUrl)/product/"
    static let OpenBeautyFacts = "itms-apps://itunes.apple.com/us/app/open-beauty-facts/id1122926380?mt=8"
    static let SupportOpenFoodFacts = "https://www.helloasso.com/associations/open-food-facts/formulaires/1/widget/en"
    static let TranslateOpenFoodFacts = "https://crowdin.com/project/openfoodfacts"
    static let FrequentlyAskedQuestions = "\(baseUrl)/faq"
    static let ProductBaseURL: String = {
        return ProductBaseURLWithLanguagePlaceholder.replacingOccurrences(of: "LANGUAGE", with: Locale.current.languageCode!)
    }()
    
    static func urlForProduct(with code: String?) -> String {
        guard let code = code else {
            return Discover
        }
        return ProductBaseURL + code
    }
}
