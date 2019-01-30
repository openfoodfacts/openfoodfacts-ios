//
//  NutritionHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 07/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionHeaderTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var nutriscoreView: NutriScoreView!

    override func configure(with formRow: FormRow) {
        if let nutriscore = formRow.value as? String, let score = NutriScoreView.Score(rawValue: nutriscore) {
            nutriscoreView.isHidden = false
            nutriscoreView.currentScore = score
        } else {
            nutriscoreView.isHidden = true
        }
    }
}
