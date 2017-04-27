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
    
    var product: Product! {
        didSet {
            calculateInfoRows()
        }
    }
    
    fileprivate var infoRows = [(ProductInfo)]()
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let headerCell = String(describing: SummaryHeaderTableViewCell.self)
    fileprivate let rowCell = String(describing: SummaryRowTableViewCell.self)
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("summary", comment: "Product detail, summary"))
    }
    
    override func viewDidLoad() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: headerCell, bundle: nil), forCellReuseIdentifier: headerCell)
        tableView.register(UINib(nibName: rowCell, bundle: nil), forCellReuseIdentifier: rowCell)
    }
    
    func calculateInfoRows() {
        // Reset
        infoRows.removeAll()
        
        // Rows of info are displayed in the order they are declared here
        checkProductPropertyExists(property: product.barcode, propertyName: .barcode)
        checkProductPropertyExists(property: product.quantity, propertyName: .quantity)
        checkProductPropertyExists(property: product.packaging, propertyName: .packaging)
        checkProductPropertyExists(property: product.brands, propertyName: .brands)
        checkProductPropertyExists(property: product.manufacturingPlaces, propertyName: .manufacturingPlaces)
        checkProductPropertyExists(property: product.origins, propertyName: .origins)
        checkProductPropertyExists(property: product.categories, propertyName: .categories)
        checkProductPropertyExists(property: product.labels, propertyName: .labels)
        checkProductPropertyExists(property: product.citiesTags, propertyName: .citiesTags)
        checkProductPropertyExists(property: product.stores, propertyName: .stores)
        checkProductPropertyExists(property: product.countries, propertyName: .countries)
    }
    
    func checkProductPropertyExists(property: String?, propertyName: ProductInfoKey) {
        if let property = property, !property.isEmpty {
            infoRows.append(ProductInfo(label: propertyName, value: property))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! SummaryHeaderTableViewCell
        
        cell.configure(withProduct: product)
        
        return cell
    }
    
    func createRow(row: Int) -> SummaryRowTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rowCell) as! SummaryRowTableViewCell
        
        let productInfo = infoRows[row]
        
        cell.configure(withProductInfo: productInfo)
        
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
