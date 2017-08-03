//
//  SummaryFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SummaryFormTableViewController: FormTableViewController {
    var summaryHeaderCellController: SummaryHeaderCellController?

    override init(with form: Form) {
        super.init(with: form)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getCell(for formRow: FormRow) -> UITableViewCell {
        if formRow.cellType is HostedViewCell.Type, let product = formRow.value as? Product {
            let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! HostedViewCell // swiftlint:disable:this force_cast
            cell.configure(with: formRow)

            let summaryHeaderCellController = SummaryHeaderCellController(with: product)
            cell.hostedView = summaryHeaderCellController.view
            self.summaryHeaderCellController = summaryHeaderCellController

            self.addChildViewController(summaryHeaderCellController)
            summaryHeaderCellController.didMove(toParentViewController: self)

            return cell
        } else {
            return super.getCell(for: formRow)
        }
    }
}
