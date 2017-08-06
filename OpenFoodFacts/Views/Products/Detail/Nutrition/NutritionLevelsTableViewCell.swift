//
//  NutritionLevelsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionLevelsTableViewCell: ProductDetailBaseCell {
    override class var estimatedHeight: CGFloat { return 292 }

    @IBOutlet weak var stackView: UIStackView!

    // TODO Using g as default, because sometimes the API does not return the _unit field and previously I was if letting the unit too, so sometimes it wasn't entering a 0-valued nutrition level and setting the UILabels. Can the unit be different to 'g', maybe for US or UK? Is it a product specific thing or by country/language/locale?

    override func configure(with formRow: FormRow) {
        guard let product = formRow.value as? Product else { return }

        if let levelView = createLevelView(level: product.nutritionLevels?.fat,
                                           item: product.nutriments?.fats[0],
                                           localizedLabel: NSLocalizedString("nutrition.fats", comment: "Nutrition, fat")) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.saturatedFat,
                                           item: product.nutriments?.fats[1],
                                           localizedLabel: NSLocalizedString("nutrition.fats.saturated-fat", comment: "Nutrition, saturated fat")) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.sugars,
                                           item: product.nutriments?.carbohydrates[1],
                                           localizedLabel: NSLocalizedString("nutrition.carbohydrate.sugars", comment: "Nutrition, sugars")) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.salt,
                                           item: product.nutriments?.salt,
                                           localizedLabel: NSLocalizedString("nutrition.salt", comment: "Nutrition, salt")) {
            stackView.addArrangedSubview(levelView)
        }
    }

    fileprivate func getLevelLocalized(level: NutritionLevel) -> String {
        switch level {
        case .low:
            return NSLocalizedString("nutrition-level.low", comment: "Nutrition Level, low")
        case .moderate:
            return NSLocalizedString("nutrition-level.moderate", comment: "Nutrition Level, moderate")
        case .high:
            return NSLocalizedString("nutrition-level.high", comment: "Nutrition Level, high")
        }
    }

    fileprivate func getImageLevel(level: NutritionLevel) -> UIImage? {
        return UIImage(named: "nutritionLevel\(level.rawValue.capitalized)")
    }

    fileprivate func createLevelView(level: NutritionLevel?, item: NutrimentItem?, localizedLabel: String) -> NutritionLevelView? {
        guard let level = level else { return nil }
        guard let item = item else { return nil }
        guard let value = item.per100g else { return nil }
        guard let levelView = Bundle.main.loadNibNamed(String(describing: NutritionLevelView.self), owner: NutritionLevelView(), options: nil)?.first as? NutritionLevelView else { return nil }

        levelView.configure(
            image: getImageLevel(level: level),
            value: "\(value.twoDecimalRounded) \(item.unit ?? "g")",
            label: localizedLabel,
            level: getLevelLocalized(level: level))

        return levelView
    }

    override func prepareForReuse() {
        stackView.removeAllViews()
    }
}
