//
//  ProductIngredientHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 01/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class IngredientHeaderTableViewCell: ConfigurableUITableViewCell<Product> {
    
    @IBOutlet weak var ingredients: UIImageView!
    
    override func configure(with product: Product, completionHandler: (() -> Void)?) {
        if let imageUrl = product.ingredientsImageUrl, let url = URL(string: imageUrl) {
            ingredients.kf.indicatorType = .activity
            ingredients.kf.setImage(with: url)
        }
    }
}
