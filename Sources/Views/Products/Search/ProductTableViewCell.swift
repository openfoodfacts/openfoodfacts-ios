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
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var novaGroupView: NovaGroupView!
    @IBOutlet weak var nutriscoreView: NutriScoreView!

    func configure(withProduct product: Product) {
        name.text = product.name ?? product.barcode

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

        if let nutriscoreValue = product.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscoreValue) {
            nutriscoreView.currentScore = score
        } else {
            nutriscoreView.isHidden = true
        }

        if let novaGroupValue = product.novaGroup,
            let novaGroup = NovaGroupView.NovaGroup(rawValue: novaGroupValue) {
            novaGroupView.novaGroup = novaGroup
        } else {
            novaGroupView.isHidden = true
        }

        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: url)
        }
    }

    func configure(withHistoryItem historyItem: HistoryItem) {
        name.text = historyItem.productName ?? historyItem.barcode

        if let quantity = historyItem.quantity, !quantity.isEmpty {
            quantityLabel.text = quantity
            quantityLabel.isHidden = false
        } else {
            quantityLabel.isHidden = true
        }

        if let brand = historyItem.brand {
            brandLabel.text = brand
            brandLabel.isHidden = false
        } else {
            brandLabel.isHidden = true
        }

        if let imageUrl = historyItem.imageUrl, let url = URL(string: imageUrl) {
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: url)
        }

        if let nutriscoreValue = historyItem.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscoreValue) {
            nutriscoreView.currentScore = score
        } else {
            nutriscoreView.isHidden = true
        }

        if let novaGroupValue = historyItem.novagroup,
            let novaGroup = NovaGroupView.NovaGroup(rawValue: novaGroupValue) {
            novaGroupView.isHidden = false
            novaGroupView.novaGroup = novaGroup
        } else {
            novaGroupView.isHidden = true
        }
    }

    override func prepareForReuse() {
        quantityLabel.isHidden = false
        brandLabel.isHidden = false
        nutriscoreView.isHidden = false
        novaGroupView.isHidden = false
        photo.kf.cancelDownloadTask()
        photo.image = #imageLiteral(resourceName: "image-add-button")
    }
}
