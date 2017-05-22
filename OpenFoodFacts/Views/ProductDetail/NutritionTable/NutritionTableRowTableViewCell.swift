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
    
    override func configure(with infoRow: InfoRow) {
        rowLabel.text = infoRow.label.localizedString
        valuePer100g.text = infoRow.value
        valuePerServing.text = infoRow.secondaryValue
    }
}
