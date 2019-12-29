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
    var ingredientList: [Ingredient]?

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        guard let product = formRow.value as? Product else { return }

        guard let ingredientsAnalysisDetails = product.ingredientsAnalysisDetails else { return }

        ingredientList = product.ingredientsListAnalysis

        for detail in ingredientsAnalysisDetails {
            switch detail.type {
            case IngredientsAnalysisType.palmOil:
                palmOilView.configure(detail: detail)
            case IngredientsAnalysisType.vegetarian:
                vegetarianView.configure(detail: detail)
            case IngredientsAnalysisType.vegan:
                veganView.configure(detail: detail)
            default:
                break
            }
        }

        palmOilView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        palmOilView.isUserInteractionEnabled = true

        vegetarianView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        vegetarianView.isUserInteractionEnabled = true

        veganView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        veganView.isUserInteractionEnabled = true

        self.viewController = viewController
    }

    func getListIngredients(status: String, view: IngredientsAnalysisView) -> String {
        var text = " "
        guard let list = ingredientList else { return text }
        for ingredient in list {
            if view == vegetarianView {
                if ingredient.vegetarian != nil && ingredient.vegetarian == status && ingredient.text != nil {
                    if text != " " { text += ", " }
                    text += ingredient.text!.replacingOccurrences(of: "_", with: "")
                }
            } else {
                if ingredient.vegan != nil && ingredient.vegan == status && ingredient.text != nil {
                    if text != " " { text += ", " }
                    text += ingredient.text!.replacingOccurrences(of: "_", with: "")
                }
            }
        }
        return text
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? IngredientsAnalysisView else { return }
        var message = view.title
        if view != palmOilView {
            if view.detail.tag.contains("non") || view.detail.tag.contains("maybe") {
                message = String(format: InfoRowKey.ingredientsInThisProduct.localizedString, view.title.lowercased())
                message += self.getListIngredients(status: view.detail.tag.contains("non") ? "no" : "maybe", view: view)
            } else if view.detail.tag.contains("unknown") {
                message = String(format: InfoRowKey.ingredientsUnknownStatus.localizedString, view.title.lowercased())
            } else {
                message = String(format: InfoRowKey.ingredientsInThisProductAre.localizedString, view.title.lowercased())
            }
        }
        let alertController = UIAlertController(title: view.title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
