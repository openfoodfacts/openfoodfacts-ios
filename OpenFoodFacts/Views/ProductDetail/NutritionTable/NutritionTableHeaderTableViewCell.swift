//
//  NutritionTableHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 12/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class NutritionTableHeaderTableViewCell: ConfigurableUITableViewCell<Product> {
    
    @IBOutlet weak var nutritionTableImage: UIImageView!
    @IBOutlet weak var servingSizeLabel: UILabel!
    
    override func configure(with product: Product) {
        if let imageUrl = product.ingredientsImageUrl, let url = URL(string: imageUrl) {
            nutritionTableImage.kf.indicatorType = .activity
            nutritionTableImage.kf.setImage(with: url)
        }
        
        servingSizeLabel.text = product.servingSize
    }
}
