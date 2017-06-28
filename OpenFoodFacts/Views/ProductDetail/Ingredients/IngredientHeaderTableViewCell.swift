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
    @IBOutlet weak var callToActionView: PictureCallToActionView!
    
    override func configure(with product: Product, completionHandler: (() -> Void)?) {
        if let imageUrl = product.ingredientsImageUrl, let url = URL(string: imageUrl) {
            ingredients.kf.indicatorType = .activity
            ingredients.kf.setImage(with: url, options: [.processor(RotatingProcessor())]) {
                (image, error, cacheType, imageUrl) in
                
                // When the image is not cached in memory, call completion handler so the cell is reloaded and resized properly
                if cacheType != .memory, let completionHandler = completionHandler {
                    completionHandler()
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            ingredients.addGestureRecognizer(tap)
            ingredients.isUserInteractionEnabled = true
        } else {
            ingredients.isHidden = true
            callToActionView.isHidden = false
            callToActionView.textLabel.text = NSLocalizedString("call-to-action.ingredients", comment: "")
        }
    }
    
    func didTapProductImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTap(imageView: ingredients, sender: self)
    }
    
    override func prepareForReuse() {
        ingredients.isHidden = false
        callToActionView.isHidden = true
    }
}
