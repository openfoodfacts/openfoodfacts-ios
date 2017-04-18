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
    
    var product: Product!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nutriscoreLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var barcode: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var packaging: UILabel!
    @IBOutlet weak var brands: UILabel!
    @IBOutlet weak var categories: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Summary")
    }
    
    override func viewDidLoad() {
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            // TODO Placeholder image or loading
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: url)
        }
        
        name.text = product.name
        barcode.text = product.barcode
        quantity.text = product.quantity
        packaging.text = product.packaging?.replacingOccurrences(of: ",", with: ", ")
    }
}
