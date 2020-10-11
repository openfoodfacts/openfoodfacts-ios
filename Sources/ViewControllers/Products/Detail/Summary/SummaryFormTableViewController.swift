//
//  SummaryFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SummaryFormTableViewController: FormTableViewController {
    var hideSummary: Bool = false

    var summaryHeaderCellController: SummaryHeaderCellController?

    override init(with form: Form, dataManager: DataManagerProtocol) {
        super.init(with: form, dataManager: dataManager)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getCell(for formRow: FormRow) -> UITableViewCell {
        if formRow.cellType is SummaryHeaderCell.Type, let product = formRow.value as? Product {
            let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! HostedViewCell // swiftlint:disable:this force_cast
            cell.configure(with: formRow, in: self)

            let summaryHeaderCellController = SummaryHeaderCellController(with: product, dataManager: dataManager, hideSummary: hideSummary)
            cell.hostedView = summaryHeaderCellController.view
            self.summaryHeaderCellController = summaryHeaderCellController

            self.addChild(summaryHeaderCellController)
            summaryHeaderCellController.didMove(toParent: self)

            return cell
        } else {
            return super.getCell(for: formRow)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is SummaryHeaderCell, let summaryHeaderCellController = summaryHeaderCellController {
            self.addChild(summaryHeaderCellController)
            summaryHeaderCellController.didMove(toParent: self)
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is SummaryHeaderCell {
            self.summaryHeaderCellController?.view.removeFromSuperview()
            self.summaryHeaderCellController?.willMove(toParent: nil)
            self.summaryHeaderCellController?.removeFromParent()
        }
    }
}
