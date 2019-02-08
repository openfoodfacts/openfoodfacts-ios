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

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let product = formRow.value as? Product else { return }

        if let levelView = createLevelView(level: product.nutritionLevels?.fat,
                                           item: getNutritionItem(at: 0, from: product.nutriments?.fats),
                                           localizedLabel: "nutrition.fats".localized) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.saturatedFat,
                                           item: getNutritionItem(at: 1, from: product.nutriments?.fats),
                                           localizedLabel: "nutrition.fats.saturated-fat".localized) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.sugars,
                                           item: getNutritionItem(at: 1, from: product.nutriments?.carbohydrates),
                                           localizedLabel: "nutrition.carbohydrate.sugars".localized) {
            stackView.addArrangedSubview(levelView)
        }
        if let levelView = createLevelView(level: product.nutritionLevels?.salt,
                                           item: product.nutriments?.salt,
                                           localizedLabel: "nutrition.salt".localized) {
            stackView.addArrangedSubview(levelView)
        }
    }

    fileprivate func getLevelLocalized(level: NutritionLevel) -> String {
        switch level {
        case .low:
            return "nutrition-level.low".localized
        case .moderate:
            return "nutrition-level.moderate".localized
        case .high:
            return "nutrition-level.high".localized
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
            value: "\(value.twoDecimalRounded) \(item.unit ?? "")",
            label: localizedLabel,
            level: getLevelLocalized(level: level))

        return levelView
    }

    private func getNutritionItem(at index: Int, from: [NutrimentItem]?) -> NutrimentItem? {
        guard let array = from else { return nil }
        if array.count > index {
            return array[index]
        } else {
            return nil
        }
    }

    override func prepareForReuse() {
        stackView.removeAllViews()
    }
}
