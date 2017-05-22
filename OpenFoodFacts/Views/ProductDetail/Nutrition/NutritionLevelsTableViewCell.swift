//
//  NutritionLevelsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionLevelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fatImageLevel: UIImageView!
    @IBOutlet weak var fatValue: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatLabelLevel: UILabel!
    
    @IBOutlet weak var saturatedFatImageLevel: UIImageView!
    @IBOutlet weak var saturatedFatValue: UILabel!
    @IBOutlet weak var saturatedFatLabel: UILabel!
    @IBOutlet weak var saturatedFatLabelLevel: UILabel!
    
    @IBOutlet weak var sugarsImageLevel: UIImageView!
    @IBOutlet weak var sugarsValue: UILabel!
    @IBOutlet weak var sugarsLabel: UILabel!
    @IBOutlet weak var sugarsLabelLevel: UILabel!
    
    @IBOutlet weak var saltImageLevel: UIImageView!
    @IBOutlet weak var saltValue: UILabel!
    @IBOutlet weak var saltLabel: UILabel!
    @IBOutlet weak var saltLabelLevel: UILabel!
    
    func configure(with product: Product) {
        // Fat
        if let fatLevel = product.nutritionLevels?.fat {
            fatImageLevel.image = getImageLevel(level: fatLevel)
            fatLabelLevel.text = getLevelLocalized(level: fatLevel)
        }
        fatLabel.text = NSLocalizedString("nutrition.fats", comment: "Nutrition, fat")
        if let fat = product.nutriments?.fats.fat, let value = fat.per100g, let unit = fat.unit {
            fatValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Saturated Fat
        if let saturatedFatLevel = product.nutritionLevels?.saturatedFat {
            saturatedFatImageLevel.image = getImageLevel(level: saturatedFatLevel)
            saturatedFatLabelLevel.text = getLevelLocalized(level: saturatedFatLevel)
        }
        saturatedFatLabel.text = NSLocalizedString("nutrition.fats.saturated-fat", comment: "Nutrition, saturated fat")
        if let saturatedFat = product.nutriments?.fats.saturatedFat, let value = saturatedFat.per100g, let unit = saturatedFat.unit {
            saturatedFatValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Sugars
        if let sugarsLevel = product.nutritionLevels?.sugars {
            sugarsImageLevel.image = getImageLevel(level: sugarsLevel)
            sugarsLabelLevel.text = getLevelLocalized(level: sugarsLevel)
        }
        sugarsLabel.text = NSLocalizedString("nutrition.carbohydrate.sugars", comment: "Nutrition, sugars")
        if let sugars = product.nutriments?.carbohydrates.sugars, let value = sugars.per100g, let unit = sugars.unit {
            sugarsValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Salt
        if let saltLevel = product.nutritionLevels?.salt {
            saltImageLevel.image = getImageLevel(level: saltLevel)
            saltLabelLevel.text = getLevelLocalized(level: saltLevel)
        }
        saltLabel.text = NSLocalizedString("nutrition.salt", comment: "Nutrition, salt")
        if let salt = product.nutriments?.salt, let value = salt.per100g, let unit = salt.unit {
            saltValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
    }
    
    fileprivate func getLevelLocalized(level: NutritionLevel) -> String {
        switch level {
        case .Low:
            return NSLocalizedString("nutrition-level.low", comment: "Nutrition Level, low")
        case .Moderate:
            return NSLocalizedString("nutrition-level.moderate", comment: "Nutrition Level, moderate")
        case .High:
            return NSLocalizedString("nutrition-level.high", comment: "Nutrition Level, high")
        }
    }
    
    func getImageLevel(level: NutritionLevel) -> UIImage? {
        return UIImage(named: "nutritionLevel\(level.rawValue.capitalized)")
    }
}
