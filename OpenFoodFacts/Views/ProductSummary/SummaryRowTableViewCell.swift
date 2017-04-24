//
//  SummaryRowTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 22/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SummaryRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(withProductInfo productInfo: ProductInfo) {
        let bold = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
        let regular = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        
        let label = NSAttributedString(string: productInfo.label.rawValue + ": ", attributes: bold)
        let value = NSAttributedString(string: productInfo.value, attributes: regular)
        
        let combination = NSMutableAttributedString()
        
        combination.append(label)
        combination.append(value)
        
        self.label.attributedText = combination
    }
}
