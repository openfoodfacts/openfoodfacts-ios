//
//  ProductSummaryViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductSummaryTableViewController: UIViewController, IndicatorInfoProvider {
    
    fileprivate lazy var tableView = UITableView()
    fileprivate var product: Product! {
        didSet {
            calculateInfoRows()
        }
    }
    fileprivate var infoRows = [InfoRow]()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("product-detail.page-title.summary", comment: "Product detail, summary"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: SummaryHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SummaryHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: SummaryRowTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SummaryRowTableViewCell.identifier)
    }
    
    func calculateInfoRows() {
        // Reset
        infoRows.removeAll()
        
        // Rows of info are displayed in the order they are declared here
        checkProductPropertyExists(property: product.barcode, propertyName: .barcode)
        checkProductPropertyExists(property: product.quantity, propertyName: .quantity)
        checkProductPropertyExists(property: product.packaging.joined(separator: ", "), propertyName: .packaging)
        checkProductPropertyExists(property: product.brands.joined(separator: ", "), propertyName: .brands)
        checkProductPropertyExists(property: product.manufacturingPlaces, propertyName: .manufacturingPlaces)
        checkProductPropertyExists(property: product.origins, propertyName: .origins)
        checkProductPropertyExists(property: product.categories.joined(separator: ", "), propertyName: .categories)
        checkProductPropertyExists(property: product.labels.joined(separator: ", "), propertyName: .labels)
        checkProductPropertyExists(property: product.citiesTags, propertyName: .citiesTags)
        checkProductPropertyExists(property: product.stores.joined(separator: ", "), propertyName: .stores)
        checkProductPropertyExists(property: product.countries.joined(separator: ", "), propertyName: .countries)
    }
    
    func checkProductPropertyExists(property: String?, propertyName: InfoRowKey) {
        if let property = property, !property.isEmpty {
            infoRows.append(InfoRow(label: propertyName, value: property))
        }
    }
}

extension ProductSummaryTableViewController: UITableViewDataSource {
    
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
    
    func createHeaderCell() -> SummaryHeaderTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SummaryHeaderTableViewCell.identifier) as! SummaryHeaderTableViewCell
        
        cell.configure(with: product)
        
        return cell
    }
    
    func createRow(row: Int) -> SummaryRowTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SummaryRowTableViewCell.identifier) as! SummaryRowTableViewCell
        
        let infoRow = infoRows[row]
        
        cell.configure(with: infoRow)
        
        return cell
    }
}

extension ProductSummaryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
    }
}
