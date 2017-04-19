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
        let header = String(describing: SummaryHeaderTableViewCell.self)
        
        tableView.register(UINib(nibName: header, bundle: nil), forCellReuseIdentifier: header)
    }
}

extension ProductSummaryTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return nil
    }
}
