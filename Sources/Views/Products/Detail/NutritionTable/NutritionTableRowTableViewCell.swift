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

    //fileprivate let fontSize: CGFloat = 16

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let nutritionTableRow = formRow.value as? NutritionTableRow else { return }
        let body = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize)
        let headline = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline).pointSize)
        let attributes = [NSAttributedString.Key.font: nutritionTableRow.highlight ? headline : body]

        rowLabel.attributedText = NSAttributedString(string: nutritionTableRow.label, attributes: attributes)
        valuePer100g.attributedText = NSAttributedString(string: nutritionTableRow.perSizeValue, attributes: attributes)

        if let perServing = nutritionTableRow.perServingValue {
            valuePerServing.attributedText = NSAttributedString(string: perServing, attributes: attributes)
        } else {
            valuePerServing.attributedText = nil
        }
    }
}
