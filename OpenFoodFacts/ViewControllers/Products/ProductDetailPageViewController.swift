//
//  ProductDetailPageViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Agrume

/// Generic Product Detail page view controller. H is the header or main row, R is one of the rows with information.
class ProductDetailPageViewController<H: ConfigurableUITableViewCell<Product>, R: ConfigurableUITableViewCell<InfoRow>>: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    internal lazy var tableView = UITableView()
    internal let product: Product
    internal let infoRows: [InfoRow]
    internal let localizedTitle: String
    
    init(product: Product, localizedTitle: String, infoRows: [InfoRow]) {
        self.product = product
        self.infoRows = infoRows
        self.localizedTitle = localizedTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func loadView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false // prevent scroll when table view fits in screen
        tableView.tableFooterView = UIView(frame: CGRect.zero) // Hide empty rows
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: H.identifier, bundle: nil), forCellReuseIdentifier: H.identifier)
        tableView.register(UINib(nibName: R.identifier, bundle: nil), forCellReuseIdentifier: R.identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return infoRows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createHeaderCell()
        }
        else {
            return createRow(row: indexPath.row)
        }
    }
    
    func createHeaderCell() -> H {
        let cell = tableView.dequeueReusableCell(withIdentifier: H.identifier) as! H
        
        cell.configure(with: product) {
            // Trigger row height recalculation due to async loaded images in dynamic height rows
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        cell.delegate = self
        
        return cell
    }
    
    func createRow(row: Int) -> R {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.identifier) as! R
        
        let infoRow = infoRows[row]
        
        cell.configure(with: infoRow)
        
        return cell
    }
    
    // MARK: - Indicator info provider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: localizedTitle)
    }
}

extension ProductDetailPageViewController: CellImageTapable {
    func didTap(image: UIImage?, sender: UITableViewCell) {
        if let image = image {
            let agrume = Agrume(image: image, backgroundColor: .black)
            agrume.showFrom(self)
        }
    }
}
