//
//  AllergensHelper.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 05/05/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class AllergensHelper {
    static func allergenAlertControllerIfNeeded(forProduct product: Product, inDataManager dataManager: DataManagerProtocol) -> UIAlertController? {
        let productAllergens = product.allergens ?? []

        let allergensAlerts = dataManager.listAllergies()
        let allergens = allergensAlerts.map { $0 }.filter { (allergen: Allergen) -> Bool in
            for productAllergen in productAllergens where productAllergen.languageCode + ":" + productAllergen.value == allergen.code {
                return true
            }
            return false
        }

        if allergens.isEmpty == false {
            let names = allergens.compactMap { $0.names.chooseForCurrentLanguage()?.value }
                .joined(separator: ", ")

            let alert = UIAlertController(title: "⚠️ " + "product-detail.ingredients.allergens-alert.title".localized, message: names, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in }
            alert.addAction(okAction)
            return alert
        }

        return nil
    }
}
