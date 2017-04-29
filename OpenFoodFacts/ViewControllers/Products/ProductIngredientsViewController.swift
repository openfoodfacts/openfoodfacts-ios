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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("product-detail.page-title.ingredients", comment: "Product details, ingredients"))
    }
}
