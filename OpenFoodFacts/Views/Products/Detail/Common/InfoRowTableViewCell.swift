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
        guard let rowLabel = formRow.label else { return }
        guard let value = formRow.getValueAsString() else { return }

        let bold = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: textSize)]
        let regular = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: textSize)]

        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: rowLabel + ": ", attributes: bold))
        combination.append(NSAttributedString(string: value, attributes: regular))

        self.label.attributedText = combination
    }
}
