//
//  ProductNutritionViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductNutritionViewController: ProductDetailPageViewController<NutritionHeaderTableViewCell, InfoRowTableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: NutritionLevelsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NutritionLevelsTableViewCell.identifier)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 292
        default:
            return 44
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        default:
            return infoRows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return super.createHeaderCell()
        case 2:
            return createNutritionLevelsCell()
        default:
            return super.createRow(row: indexPath.row)
        }
    }
    
    func createNutritionLevelsCell() -> NutritionLevelsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionLevelsTableViewCell.identifier) as! NutritionLevelsTableViewCell
        
        cell.configure(with: product)
        
        return cell
    }
}
