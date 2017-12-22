//
//  NutritionTableFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class NutritionTableFormTableViewController: FormTableViewController {
    var nutritionTableHeaderCellController: NutritionTableHeaderCellController?

    override init(with form: Form, dataManager: DataManagerProtocol) {
        super.init(with: form, dataManager: dataManager)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getCell(for formRow: FormRow) -> UITableViewCell {
        if formRow.cellType is HostedViewCell.Type, let product = formRow.value as? Product {
            let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! HostedViewCell // swiftlint:disable:this force_cast
            cell.configure(with: formRow)

            let nutritionTableHeaderCellController = NutritionTableHeaderCellController(with: product, dataManager: dataManager)
            nutritionTableHeaderCellController.delegate = self
            cell.hostedView = nutritionTableHeaderCellController.view
            self.nutritionTableHeaderCellController = nutritionTableHeaderCellController

            self.addChildViewController(nutritionTableHeaderCellController)
            nutritionTableHeaderCellController.didMove(toParentViewController: self)

            return cell
        } else {
            return super.getCell(for: formRow)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell, let nutritionTableHeaderCellController = nutritionTableHeaderCellController {
            self.addChildViewController(nutritionTableHeaderCellController)
            nutritionTableHeaderCellController.didMove(toParentViewController: self)
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell {
            self.nutritionTableHeaderCellController?.view.removeFromSuperview()
            self.nutritionTableHeaderCellController?.willMove(toParentViewController: nil)
            self.nutritionTableHeaderCellController?.removeFromParentViewController()
        }
    }
}
