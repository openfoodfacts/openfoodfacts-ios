//
//  PictureTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var dataStackView: UIStackView!

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var pictureLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func configure(viewModel: PictureViewModel) {
        activityIndicator.color = UIColor.black

        if viewModel.isUploading {
            UIView.animate(withDuration: 0.2) {
                self.dataStackView.alpha = 0
                self.activityIndicator.startAnimating()
            }
        } else {
            if let text = viewModel.text {
                pictureButton.setTitle(text, for: .normal)
            }

            if let image = viewModel.image {
                pictureView.image = image
                pictureView.isHidden = false
                pictureButton.isHidden = true
                pictureLabel.isHidden = false
                pictureLabel.text = viewModel.uploadedPictureText
            } else {
                pictureView.isHidden = true
                pictureButton.isHidden = false
                pictureLabel.isHidden = true
            }
            UIView.animate(withDuration: 0.2) {
                self.dataStackView.alpha = 1
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
