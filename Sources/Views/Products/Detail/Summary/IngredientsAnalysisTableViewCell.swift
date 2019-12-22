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

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let product = formRow.value as? Product else { return }

        guard let ingredientsAnalysisDetails = product.ingredientsAnalysisDetails else { return }
        
        for detail in ingredientsAnalysisDetails {
            switch detail.type {
            case IngredientsAnalysisType.palmOil:
                palmOilView.configure(imageURL: detail.icon, color: detail.color)
            case IngredientsAnalysisType.vegetarian:
                vegetarianView.configure(imageURL: detail.icon, color: detail.color)
            case IngredientsAnalysisType.vegan:
                veganView.configure(imageURL: detail.icon, color: detail.color)
            default:
                break
            }
        }
    }
}
