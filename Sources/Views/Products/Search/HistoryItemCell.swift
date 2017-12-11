//
//  HistoryItemCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 16/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class HistoryItemCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var brandQuantityStackView: UIStackView!
    @IBOutlet weak var nutriscoreView: SingleLetterNutriscoreView!

    func configure(_ historyItem: HistoryItem) {
        nameLabel.text = historyItem.productName ?? historyItem.barcode

        if let quantity = historyItem.quantity, !quantity.isEmpty {
            quantityLabel.text = quantity
        } else {
            quantityLabel.isHidden = true
        }

        if let brand = historyItem.brand {
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

        if let imageUrl = historyItem.imageUrl, let url = URL(string: imageUrl) {
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url)
        }

        if let nutriscore = historyItem.nutriscore {
            nutriscoreView.isHidden = false
            nutriscoreView.nutriscore = Nutriscore(rawValue: nutriscore)
        } else {
            nutriscoreView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let nutriscoreViewBackgroundColor = nutriscoreView.contentView.backgroundColor

        super.setSelected(selected, animated: animated)

        if selected {
            nutriscoreView.contentView.backgroundColor = nutriscoreViewBackgroundColor
        }
    }
}
