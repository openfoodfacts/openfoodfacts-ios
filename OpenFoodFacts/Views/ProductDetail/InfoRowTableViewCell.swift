//
//  ProductIngredientsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class InfoRowTableViewCell: ConfigurableUITableViewCell<InfoRow> {

    @IBOutlet weak var label: UILabel!
    fileprivate let textSize: CGFloat = 17

    override func configure(with infoRow: InfoRow, completionHandler: (() -> Void)?) {
        let bold = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: textSize)]
        let regular = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: textSize)]

        let label = NSAttributedString(string: infoRow.label.localizedString + ": ", attributes: bold)
        let value = NSAttributedString(string: infoRow.value, attributes: regular)

        let combination = NSMutableAttributedString()

        combination.append(label)
        combination.append(value)

        self.label.attributedText = combination
    }
}
