//
//  IngredientsAnalysisTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 14/10/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class IngredientsAnalysisTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var stackView: UIStackView!

    var viewController: FormTableViewController?

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let product = formRow.value as? Product else { return }

        guard let ingredientsAnalysisDetails = product.ingredientsAnalysisDetails else { return }

        for detail in ingredientsAnalysisDetails {
            let analysisView = IngredientsAnalysisView.loadFromNib()
            analysisView.configure(detail: detail, ingredientsList: product.ingredientsListAnalysis)
            analysisView.configureGestureRecognizer()
            stackView.addArrangedSubview(analysisView)
        }

        self.viewController = viewController
    }

    func dismiss() {
        stackView.arrangedSubviews.forEach {
            if let view = $0 as? IngredientsAnalysisView {
                view.removeGestureRecognizer()
            }
        }
        stackView.removeAllViews()
    }
}
