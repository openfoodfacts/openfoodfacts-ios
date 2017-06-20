//
//  ProductTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    func configure(withProduct product: Product) {
        name.text = product.name
        
        if let quantity = product.quantity, !quantity.isEmpty {
            quantityLabel.text = quantity
        } else {
            quantityLabel.isHidden = true
        }
        
        if let brand = product.brands?[0], !brand.isEmpty {
            brandLabel.text = brand
        } else {
            brandLabel.isHidden = true
        }
        
        if brandLabel.isHidden || quantityLabel.isHidden {
            separatorLabel.isHidden = true
        }
        
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        quantityLabel.isHidden = false
        brandLabel.isHidden = false
        separatorLabel.isHidden = false
    }
}
