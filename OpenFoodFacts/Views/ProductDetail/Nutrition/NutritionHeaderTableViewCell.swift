//
//  NutritionHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 07/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionHeaderTableViewCell: ConfigurableUITableViewCell<Product> {
    
    @IBOutlet weak var nutriscoreView: NutriScoreView!
    
    override func configure(with product: Product, completionHandler: (() -> Void)?) {
        if let nutriscore = product.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscore.uppercased()) {
            nutriscoreView.isHidden = false
            nutriscoreView.currentScore = score
        } else {
            nutriscoreView.isHidden = true
        }
    }
}
