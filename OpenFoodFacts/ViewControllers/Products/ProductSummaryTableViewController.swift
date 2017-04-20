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
    
    var product: Product!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate         let headerCell = String(describing: SummaryHeaderTableViewCell.self)
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Summary")
    }
    
    override func viewDidLoad() {
        configureTableView()
        
        
        //        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
        //            // TODO Placeholder image or loading
        //            photo.kf.indicatorType = .activity
        //            photo.kf.setImage(with: url)
        //        }
        //
        //        name.text = product.name
        //        barcode.text = product.barcode
        //        quantity.text = product.quantity
        //        packaging.text = product.packaging?.replacingOccurrences(of: ",", with: ", ")
        //        brands.text = product.brands
        //        categories.text = product.categories
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: headerCell, bundle: nil), forCellReuseIdentifier: headerCell)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 188
    }
}

extension ProductSummaryTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            return 0 // TODO how can I know how many rows? It depends on the number of non-nil properties in the product object
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return createHeaderCell(row: indexPath.row)
        }
        else {
            return UITableViewCell() // TODO
        }
    }
    
    func createHeaderCell(row: Int) -> SummaryHeaderTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! SummaryHeaderTableViewCell
        
        cell.configure(withProduct: product)
        
        return cell
    }
}
