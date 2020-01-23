//
//  IngredientsAnalysisTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 14/10/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class IngredientsAnalysisTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var palmOilView: IngredientsAnalysisView!
    @IBOutlet weak var vegetarianView: IngredientsAnalysisView!
    @IBOutlet weak var veganView: IngredientsAnalysisView!
    var viewController: FormTableViewController?

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let product = formRow.value as? Product else { return }

        guard let ingredientsAnalysisDetails = product.ingredientsAnalysisDetails else { return }

        palmOilView.isHidden = true
        vegetarianView.isHidden = true
        veganView.isHidden = true

        for detail in ingredientsAnalysisDetails {
            switch detail.type {
            case IngredientsAnalysisType.palmOil:
                palmOilView.isHidden = false
                palmOilView.configure(detail: detail, ingredientsList: product.ingredientsListAnalysis)
            case IngredientsAnalysisType.vegetarian:
                vegetarianView.isHidden = false
                vegetarianView.configure(detail: detail, ingredientsList: product.ingredientsListAnalysis)
            case IngredientsAnalysisType.vegan:
                veganView.isHidden = false
                veganView.configure(detail: detail, ingredientsList: product.ingredientsListAnalysis)
            default:
                break
            }
        }

        palmOilView.configureGestureRecognizer()
        vegetarianView.configureGestureRecognizer()
        veganView.configureGestureRecognizer()

        self.viewController = viewController
    }

    func dismiss() {
        palmOilView.removeGestureRecognizer()
        vegetarianView.removeGestureRecognizer()
        veganView.removeGestureRecognizer()
    }
}
