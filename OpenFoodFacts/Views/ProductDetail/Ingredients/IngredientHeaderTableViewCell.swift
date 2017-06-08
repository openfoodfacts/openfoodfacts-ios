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
            ingredients.kf.setImage(with: url, options: [.processor(RotatingProcessor())]) {
                (image, error, cacheType, imageUrl) in
                DispatchQueue.main.async {
                    self.setNeedsLayout()
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            ingredients.addGestureRecognizer(tap)
            ingredients.isUserInteractionEnabled = true
        }
    }
    
    func didTapProductImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTap(image: ingredients.image, sender: self)
    }
}
