//
//  EnvironmentFormViewController.swift
//  OpenFoodFacts
//
//  Created by arnaud on 21/11/2020.
//

import UIKit

class EnvironmentFormTableViewController: FormTableViewController {

    var environmentHeaderCellController: EnvironmentHeaderCellController?

    override init(with form: Form, dataManager: DataManagerProtocol) {
        super.init(with: form, dataManager: dataManager)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getCell(for formRow: FormRow) -> UITableViewCell {
        if formRow.cellType is HostedViewCell.Type, let product = formRow.value as? Product {
            let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! HostedViewCell // swiftlint:disable:this force_cast
            cell.configure(with: formRow, in: self)

            let environmentHeaderCellController = EnvironmentHeaderCellController(with: product, dataManager: dataManager)
            environmentHeaderCellController.delegate = self
            cell.hostedView = environmentHeaderCellController.view
            self.environmentHeaderCellController = environmentHeaderCellController

            self.addChild(environmentHeaderCellController)
            environmentHeaderCellController.didMove(toParent: self)

            return cell
        } else {
            return super.getCell(for: formRow)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell, let environmentHeaderCellController = environmentHeaderCellController {
            self.addChild(environmentHeaderCellController)
            environmentHeaderCellController.didMove(toParent: self)
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HostedViewCell {
            self.environmentHeaderCellController?.view.removeFromSuperview()
            self.environmentHeaderCellController?.willMove(toParent: nil)
            self.environmentHeaderCellController?.removeFromParent()
        }
    }
}
