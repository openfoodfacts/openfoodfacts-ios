//
//  IngredientsFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 05/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class IngredientsFormTableViewController: FormTableViewController {
    var ingredientsHeaderCellController: IngredientsHeaderCellController?

    override init(with form: Form, productApi: ProductApi) {
        super.init(with: form, productApi: productApi)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getCell(for formRow: FormRow) -> UITableViewCell {
        if formRow.cellType is HostedViewCell.Type, let product = formRow.value as? Product {
            let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! HostedViewCell // swiftlint:disable:this force_cast
            cell.configure(with: formRow)

            let ingredientsHeaderCellController = IngredientsHeaderCellController(with: product, productApi: productApi)
            ingredientsHeaderCellController.delegate = self
            cell.hostedView = ingredientsHeaderCellController.view
            self.ingredientsHeaderCellController = ingredientsHeaderCellController

            return cell
        } else {
            return super.getCell(for: formRow)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell, let ingredientsHeaderCellController = ingredientsHeaderCellController {
            self.addChildViewController(ingredientsHeaderCellController)
            ingredientsHeaderCellController.didMove(toParentViewController: self)
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell {
            self.ingredientsHeaderCellController?.view.removeFromSuperview()
            self.ingredientsHeaderCellController?.willMove(toParentViewController: nil)
            self.ingredientsHeaderCellController?.removeFromParentViewController()
        }
    }
}
