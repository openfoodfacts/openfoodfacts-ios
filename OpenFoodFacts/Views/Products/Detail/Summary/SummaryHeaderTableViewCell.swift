//
//  SummaryHeaderTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class SummaryHeaderTableViewCell: ConfigurableUITableViewCell<Product> {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var nutriscore: NutriScoreView! {
        didSet {
            nutriscore?.currentScore = nil
        }
    }
    @IBOutlet weak var productName: UILabel!

    override func configure(with product: Product, completionHandler: (() -> Void)?) {
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url)

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            productImage.addGestureRecognizer(tap)
            productImage.isUserInteractionEnabled = true
        } else {
            productImage.isHidden = true
            callToActionView.textLabel.text = NSLocalizedString("call-to-action.summary", comment: "")
            callToActionView.isHidden = false
        }

        if let nutriscoreValue = product.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscoreValue.uppercased()) {
            nutriscore.currentScore = score
        } else {
            nutriscore.superview?.isHidden = true
        }

        if let name = product.name {
            productName.text = name
        } else {
            productName.isHidden = true
        }
    }

    func didTapProductImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTap(imageView: productImage, sender: self)
    }

    override func prepareForReuse() {
        productImage.isHidden = false
        callToActionView.isHidden = true
        nutriscore.superview?.isHidden = false
        productName.isHidden = false
    }
}
