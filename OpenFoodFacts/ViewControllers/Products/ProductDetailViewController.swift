//
//  ProductDetailViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductDetailViewController: ButtonBarPagerTabStripViewController {
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBarView.register(UINib(nibName: "ButtonBarView", bundle: nil), forCellWithReuseIdentifier: "Cell")
        buttonBarView.backgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = self.view.tintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()
        
        if let summary = UIStoryboard(name: String(describing: ProductSummaryTableViewController.self), bundle: nil).instantiateInitialViewController() as? ProductSummaryTableViewController {
            summary.product = product
            vcs.append(summary)
        }
        
        vcs.append(ProductIngredientsViewController(product: product))
        
        if let nutrition = UIStoryboard(name: String(describing: ProductNutritionViewController.self), bundle: nil).instantiateInitialViewController() as? ProductNutritionViewController {
            vcs.append(nutrition)
        }
        
        return vcs
    }
}
