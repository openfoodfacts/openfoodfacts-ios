//
//  ProductSummaryViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductSummaryViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Summary")
    }
}
