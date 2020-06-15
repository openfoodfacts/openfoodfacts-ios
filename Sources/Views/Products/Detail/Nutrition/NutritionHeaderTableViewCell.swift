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
        } else {
            nutriscoreView.isHidden = true
        }
        self.noFiberWarning = nutriscoreTableRow.noFiberWarning
        self.noFruitsVegetablesNutsWarning = nutriscoreTableRow.noFruitsVegetablesNutsWarning

        self.delegate = nutriscoreTableRow.delegate
    }

    @IBOutlet weak var noFruitsVegetablesNutsDisclaimerLabel: UILabel! {
        didSet {
            setNoFruitsVegetablesNutsDisclaimer()
        }
    }
    @IBOutlet weak var noFiberDisclaimerLabel: UILabel! {
        didSet {
            setNoFiberDisclaimer()
        }
    }
    
    /// The product has no fibers specified. The calculated NutriScore might be incorrect.
        public var noFiberWarning: Bool = false {
            didSet {
                setNoFiberDisclaimer()
            }
        }

    /// Initialize the label, which shows the fiber disclaimer. If there is no warning, the disclaimer will be hidden.
        private func setNoFiberDisclaimer() {
            if noFiberWarning {
                self.noFiberDisclaimerLabel?.isHidden = false
                self.noFiberDisclaimerLabel?.text = "product-detail.nutrition-table.nutrition_grade_fr_fiber_warning".localized
            } else {
                self.noFiberDisclaimerLabel?.isHidden = true
                self.noFiberDisclaimerLabel?.text = nil
            }
        }

    /// The product has no fruits/vegetables/nuts ratio specified. The calculated NutriScore might be incorrect.
        public var noFruitsVegetablesNutsWarning: Bool = false {
            didSet {
                setNoFruitsVegetablesNutsDisclaimer()
            }
        }

        private func setNoFruitsVegetablesNutsDisclaimer() {
            if noFruitsVegetablesNutsWarning {
                self.noFruitsVegetablesNutsDisclaimerLabel?.isHidden = false
                self.noFruitsVegetablesNutsDisclaimerLabel?.text = "product-detail.nutrition-table.nutrition_grade_fr_no_fruits_vegetables_nuts_warning".localized
            } else {
                self.noFruitsVegetablesNutsDisclaimerLabel?.isHidden = true
                self.noFruitsVegetablesNutsDisclaimerLabel?.text = nil
            }
            self.noFruitsVegetablesNutsDisclaimerLabel?.preferredMaxLayoutWidth = self.bounds.size.width
        }

    public weak var delegate: NutritionHeaderTableViewCellDelegate?
}
