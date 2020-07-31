//
//  AnalyticsEvents.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 19/07/2020.
//

import Foundation

public struct View {
    var path: [String]
}

public struct Views {
    public static var Scanner = View(path: ["scanner"])
    public static var ProductEdit = View(path: ["products", "edit"])
}

public struct Event {
    var category: String
    var action: String
    var name: String?
    var value: Float?
}

public struct Events {
    struct Scanner {
        static func scanned(barcode: String) -> Event {
            return Event(category: "scanner", action: "scanned", name: barcode)
        }
        static func resultDidExpand(barcode: String) -> Event {
            return Event(category: "scanner", action: "result-expanded", name: barcode)
        }
    }
    struct AllergenAlerts {
        static func alertCreated(forAllergen: Allergen) -> Event {
            return Event(category: "allergen-alerts", action: "created", name: forAllergen.code, value: nil)
        }
    }
    struct Products {
        static func edited(barcode: String) -> Event {
            return Event(category: "products", action: "edited", name: barcode, value: nil)
        }
        static func editedNutritionFacts(barcode: String) -> Event {
            return Event(category: "products", action: "edited-nutrition-facts", name: barcode, value: nil)
        }
        static func editedIngredients(barcode: String) -> Event {
            return Event(category: "products", action: "edited-ingredients", name: barcode, value: nil)
        }
        static func editedIngredientsPicture(barcode: String) -> Event {
            return Event(category: "products", action: "edited-ingredients-picture", name: barcode, value: nil)
        }
    }
}
