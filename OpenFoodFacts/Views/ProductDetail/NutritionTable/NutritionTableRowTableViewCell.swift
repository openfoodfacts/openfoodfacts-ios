//
//  NutritionTableRowTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionTableRowTableViewCell: ConfigurableUITableViewCell<InfoRow> {
    
    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var valuePer100g: UILabel!
    @IBOutlet weak var valuePerServing: UILabel!
    
    fileprivate let fontSize: CGFloat = 17
    
    override func configure(with infoRow: InfoRow, completionHandler: (() -> Void)?) {
        let attributes = [NSFontAttributeName: infoRow.highlight ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)]
        
        rowLabel.attributedText = NSAttributedString(string: infoRow.label.localizedString, attributes: attributes)
        valuePer100g.attributedText = NSAttributedString(string: infoRow.value, attributes: attributes)
        
        if let perServing = infoRow.secondaryValue {
            valuePerServing.attributedText = NSAttributedString(string: perServing, attributes: attributes)
        }
    }
}
