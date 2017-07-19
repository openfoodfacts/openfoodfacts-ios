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

    override func configure(with product: Product, completionHandler: (() -> Void)?) {
        self.imageHeightConstraint?.constant = 30

        if let imageUrl = product.nutritionTableImage, let url = URL(string: imageUrl) {
            nutritionTableImage.kf.indicatorType = .activity
            nutritionTableImage.kf.setImage(with: url, options: [.processor(RotatingProcessor())]) { (image, _, cacheType, _) in
                if let image = image {
                    self.imageHeightConstraint?.constant = min(image.size.height, 130)
                }

                // When the image is not cached in memory, call completion handler so the cell is reloaded and resized properly
                if cacheType != .memory, let completionHandler = completionHandler {
                    completionHandler()
                }
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            nutritionTableImage.addGestureRecognizer(tap)
            nutritionTableImage.isUserInteractionEnabled = true
        }

        if let servingSize = product.servingSize {
            servingSizeLabel.text = "\(NSLocalizedString("product-detail.nutrition-table.for-serving", comment: "")): \(servingSize)"
        }
    }

    func didTapProductImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTap(imageView: nutritionTableImage, sender: self)
    }
}
