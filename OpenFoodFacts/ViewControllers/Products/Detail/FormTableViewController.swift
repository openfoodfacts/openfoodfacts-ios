//
//  FormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol FormTableViewControllerDelegate: class {
    func cellSizeDidChange()
}

class FormTableViewController: UITableViewController {
    let form: Form
    let productApi: ProductApi

    fileprivate let localizedTitle: String

    init(with form: Form, productApi: ProductApi) {
        self.form = form
        self.productApi = productApi
        localizedTitle = form.title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.alwaysBounceVertical = false // prevent scroll when table view fits in screen
        tableView.tableFooterView = UIView(frame: CGRect.zero) // Hide empty rows
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.cellLayoutMarginsFollowReadableWidth = false

        for cellType in form.getCellTypes() {
            if Bundle.main.path(forResource: cellType.identifier, ofType: "nib") != nil {
                tableView.register(UINib(nibName: cellType.identifier, bundle: nil), forCellReuseIdentifier: cellType.identifier)
            } else {
                tableView.register(cellType, forCellReuseIdentifier: cellType.identifier)
            }
        }
    }

    func getCell(for formRow: FormRow) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! ProductDetailBaseCell // swiftlint:disable:this force_cast
        cell.configure(with: formRow)
        return cell
    }
}

// MARK: - TableView Data Source
extension FormTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formRow = form.rows[indexPath.row]
        return getCell(for: formRow)
    }
}

// MARK: - TableView delegate
extension FormTableViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = form.rows[indexPath.row].cellType
        return cellType.estimatedHeight
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return form.rows[indexPath.row].isCopiable
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let formRow = form.rows[indexPath.row]
        guard let value = formRow.getValueAsString() else { return }
        UIPasteboard.general.string = value
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
}

extension FormTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: localizedTitle)
    }
}

extension FormTableViewController: FormTableViewControllerDelegate {
    func cellSizeDidChange() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
