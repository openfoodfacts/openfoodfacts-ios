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
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    func configure(withProduct product: Product) {
        name.text = product.name
        brand.text = product.brands
        quantity.text = product.quantity
        
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            // TODO Placeholder image or loading
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: url)
        }
    }
}
