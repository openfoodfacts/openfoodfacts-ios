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
        
        navigationController?.navigationBar.isTranslucent = false
        buttonBarView.register(UINib(nibName: "ButtonBarView", bundle: nil), forCellWithReuseIdentifier: "Cell")
        buttonBarView.backgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = self.view.tintColor
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcs = [UIViewController]()
        
        if let summary = UIStoryboard(name: String(describing: ProductSummaryViewController.self), bundle: nil).instantiateInitialViewController() {
            vcs.append(summary)
        }
        
        if let ingredients = UIStoryboard(name: String(describing: ProductIngredientsViewController.self), bundle: nil).instantiateInitialViewController() {
            vcs.append(ingredients)
        }
        
        if let nutrition = UIStoryboard(name: String(describing: ProductNutritionViewController.self), bundle: nil).instantiateInitialViewController() {
            vcs.append(nutrition)
        }
        
        return vcs
    }
}
