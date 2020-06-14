//
//  NutritionHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 07/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol NutritionHeaderTableViewCellDelegate: class {
    func nutritionHeaderTableViewCellDelegate(_ sender: NutritionHeaderTableViewCell, receivedTapOn button: UIButton)
}

class NutritionHeaderTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var nutriscoreLearnMoreButton: UIButton! {
        didSet {
            if #available(iOS 13.0, *) {
                nutriscoreLearnMoreButton.setImage(UIImage.init(systemName: "info.circle"), for: .normal)
            } else {
                nutriscoreLearnMoreButton.setImage(UIImage.init(named: "circle-info"), for: .normal)
            }
        }
    }

    @IBAction func nutritionscoreLearMoreButtonTapped(_ sender: UIButton) {
        delegate?.nutritionHeaderTableViewCellDelegate(self, receivedTapOn: nutriscoreLearnMoreButton)
    }

    @IBOutlet weak var nutriscoreView: NutriScoreView!

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let nutriscoreTableRow = formRow.value as? NutritionScoreTableRow else { return }

        if let nutriscore = nutriscoreTableRow.nutriscore,
            let score = NutriScoreView.Score(rawValue: nutriscore) {
            nutriscoreView.isHidden = false
            nutriscoreView.currentScore = score
            nutriscoreView.noFiberWarning = nutriscoreTableRow.noFiberWarning
            nutriscoreView.noFruitsVegetablesNutsWarning = nutriscoreTableRow.noFruitsVegetablesNutsWarning
        } else {
            nutriscoreView.isHidden = true
        }
        self.delegate = nutriscoreTableRow.delegate
    }

    public weak var delegate: NutritionHeaderTableViewCellDelegate?
}
