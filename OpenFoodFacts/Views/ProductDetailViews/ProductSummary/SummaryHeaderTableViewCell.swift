//
//  SummaryHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class SummaryHeaderTableViewCell: ConfigurableUITableViewCell<Product> {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nutriscore: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func configure(with product: Product) {
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            // TODO Placeholder image or loading
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url)
        }
        
        if let nutriscore = product.nutriscore {
            self.nutriscore.text = nutriscore.uppercased()
        }
        
        if let name = product.name {
            productName.text = name
        }
    }
}
