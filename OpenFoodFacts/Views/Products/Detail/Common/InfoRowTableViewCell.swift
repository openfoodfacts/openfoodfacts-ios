//
//  ProductIngredientsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class InfoRowTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var label: UILabel!
    fileprivate let textSize: CGFloat = 17

    override func configure(with formRow: FormRow) {
        let bold = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: textSize)]
        let regular = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: textSize)]

        let combination = NSMutableAttributedString()

        if let label = formRow.label {
            combination.append(NSAttributedString(string: label + ": ", attributes: bold))
        }

        if let value = formRow.value as? String {
            combination.append(NSAttributedString(string: value, attributes: regular))
        } else if let value = formRow.value as? [String] {
            combination.append(NSAttributedString(string: value.joined(separator: ", "), attributes: regular))
        }

        self.label.attributedText = combination
    }
}
