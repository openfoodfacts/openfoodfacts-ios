//
//  NutritionTableRowTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionTableRowTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var valuePer100g: UILabel!
    @IBOutlet weak var valuePerServing: UILabel!

    fileprivate let fontSize: CGFloat = 17

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let nutritionTableRow = formRow.value as? NutritionTableRow else { return }

        let attributes = [NSAttributedStringKey.font: nutritionTableRow.highlight ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)]

        rowLabel.attributedText = NSAttributedString(string: nutritionTableRow.label, attributes: attributes)
        valuePer100g.attributedText = NSAttributedString(string: nutritionTableRow.perSizeValue, attributes: attributes)

        if let perServing = nutritionTableRow.perServingValue {
            valuePerServing.attributedText = NSAttributedString(string: perServing, attributes: attributes)
        }
    }
}
