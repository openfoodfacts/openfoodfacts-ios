//
//  PendingUploadItemCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class PendingUploadItemCell: UITableViewCell {
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var ingredientsImage: UIImageView!
    @IBOutlet weak var nutritionImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var brandQuantityStackView: UIStackView!

    func configure(with item: PendingUploadItem) {
        productNameLabel.text = item.productName ?? item.barcode


        if let quantity = item.quantity, !quantity.isEmpty {
            quantityLabel.text = quantity
        } else {
            quantityLabel.isHidden = true
        }

        if let brand = item.brand {
            brandLabel.text = brand
        } else {
            brandLabel.isHidden = true
        }

        if brandLabel.isHidden || quantityLabel.isHidden {
            separatorLabel.isHidden = true
        }

        if brandLabel.isHidden && quantityLabel.isHidden {
            brandQuantityStackView.isHidden = true
        }

        frontImage.image = item.frontImage?.image
        ingredientsImage.image = item.ingredientsImage?.image
        nutritionImage.image = item.nutritionImage?.image
    }
}
