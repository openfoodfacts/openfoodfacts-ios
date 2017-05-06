//
//  ProductIngredientsViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductIngredientsViewController: UIViewController, IndicatorInfoProvider {
    
    lazy var tableView = UITableView()
    var product: Product!
    fileprivate var infoRows = [InfoRow]()
    
    init(product: Product) {
        super.init(nibName: nil, bundle: nil)
        
        self.product = product
        calculateInfoRows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: ProductIngredientHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductIngredientHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: ProductIngredientsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductIngredientsTableViewCell.identifier)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("product-detail.page-title.ingredients", comment: "Product details, ingredients"))
    }
    
    func calculateInfoRows() {
        // Reset
        infoRows.removeAll()
        
        // Rows of info are displayed in the order they are declared here
        checkProductPropertyExists(property: product.ingredientsList, propertyName: .ingredientsList)
        checkProductPropertyExists(property: product.allergens, propertyName: .allergens)
        checkProductPropertyExists(property: product.traces, propertyName: .traces)
        checkProductPropertyExists(property: product.additives?.map({ $0.value.uppercased() }).joined(separator: ", "), propertyName: .additives)
        checkProductPropertyExists(property: product.palmOilIngredients.joined(separator: ", "), propertyName: .palmOilIngredients)
        checkProductPropertyExists(property: product.possiblePalmOilIngredients.joined(separator: ", "), propertyName: .possiblePalmOilIngredients)
    }
    
    func checkProductPropertyExists(property: String?, propertyName: InfoRowKey) {
        if let property = property, !property.isEmpty {
            infoRows.append(InfoRow(label: propertyName, value: property))
        }
    }
}

extension ProductIngredientsViewController: UITableViewDataSource {
    
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
    
    func createHeaderCell() -> ProductIngredientHeaderTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductIngredientHeaderTableViewCell.identifier) as! ProductIngredientHeaderTableViewCell
        
        cell.configure(with: product)
        
        return cell
    }
    
    func createRow(row: Int) -> ProductIngredientsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductIngredientsTableViewCell.identifier) as! ProductIngredientsTableViewCell
        
        cell.configure(with: infoRows[row])
        
        return cell
    }
}

extension ProductIngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 44
        }
    }
}
