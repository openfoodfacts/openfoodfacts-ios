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
    @IBOutlet weak var fatLabelLevel: UILabel!
    
    @IBOutlet weak var saturatedFatImageLevel: UIImageView!
    @IBOutlet weak var saturatedFatValue: UILabel!
    @IBOutlet weak var saturatedFatLabelLevel: UILabel!
    
    @IBOutlet weak var sugarsImageLevel: UIImageView!
    @IBOutlet weak var sugarsValue: UILabel!
    @IBOutlet weak var sugarsLabelLevel: UILabel!
    
    @IBOutlet weak var saltImageLevel: UIImageView!
    @IBOutlet weak var saltValue: UILabel!
    @IBOutlet weak var saltLabelLevel: UILabel!
    
    func configure(with product: Product) {
        // Fat
        if let fatLevel = product.nutritionLevels?.fat {
            fatImageLevel.image = getImageLevel(level: fatLevel)
            fatLabelLevel.text = getLevelLocalized(level: fatLevel)
        }
        if let stringValue = product.nutriments?.fat100g, let value = Double(stringValue), let unit = product.nutriments?.fatUnit {
            fatValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Saturated Fat
        if let saturatedFatLevel = product.nutritionLevels?.saturatedFat {
            saturatedFatImageLevel.image = getImageLevel(level: saturatedFatLevel)
            saturatedFatLabelLevel.text = getLevelLocalized(level: saturatedFatLevel)
        }
        if let stringValue = product.nutriments?.saturatedFat100g, let value = Double(stringValue), let unit = product.nutriments?.saturatedFatUnit {
            saturatedFatValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Sugars
        if let sugarsLevel = product.nutritionLevels?.sugars {
            sugarsImageLevel.image = getImageLevel(level: sugarsLevel)
            sugarsLabelLevel.text = getLevelLocalized(level: sugarsLevel)
        }
        if let stringValue = product.nutriments?.sugars100g, let value = Double(stringValue), let unit = product.nutriments?.sugarsUnit {
            sugarsValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
        
        // Salt
        if let saltLevel = product.nutritionLevels?.salt {
            saltImageLevel.image = getImageLevel(level: saltLevel)
            saltLabelLevel.text = getLevelLocalized(level: saltLevel)
        }
        if let stringValue = product.nutriments?.salt100g, let value = Double(stringValue), let unit = product.nutriments?.saltUnit {
            saltValue.text = "\(value.twoDecimalRounded) \(unit)"
        }
    }
    
    fileprivate func getLevelLocalized(level: NutritionLevel) -> String {
        switch level {
        case .Low:
            return NSLocalizedString("nutrition-level.high", comment: "Nutrition Level, high")
        case .Moderate:
            return NSLocalizedString("nutrition-level.high", comment: "Nutrition Level, high")
        case .High:
            return NSLocalizedString("nutrition-level.high", comment: "Nutrition Level, high")
        }
    }
    
    func getImageLevel(level: NutritionLevel) -> UIImage? {
        return UIImage(named: "nutritionLevel\(level.rawValue.capitalized)")
    }
}
