//
//  FormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FormTableView: UITableViewController {
    let form: Form

    fileprivate let localizedTitle: String

    init(with form: Form) {
        self.form = form
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

        for cellType in form.cellTypes {
            tableView.register(UINib(nibName: cellType.identifier, bundle: nil), forCellReuseIdentifier: cellType.identifier)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
    }
}

// MARK: - TableView Data Source
extension FormTableView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formRow = form.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: formRow.cellType.identifier) as! ProductDetailBaseCell // swiftlint:disable:this force_cast
        cell.configure(with: formRow)
        return cell
    }
}

// MARK: - TableView delegate
extension FormTableView {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = form.sections[indexPath.section].rows[indexPath.row].cellType
        return cellType.estimatedHeight
    }
}

extension FormTableView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: localizedTitle)
    }
}
