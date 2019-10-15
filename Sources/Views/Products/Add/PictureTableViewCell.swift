//
//  PictureTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Kingfisher

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var dataStackView: UIStackView!

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var pictureLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        pictureView.contentMode = .scaleAspectFit
    }

    func configure(viewModel: PictureViewModel) {
        if #available(iOS 13.0, *) {
            activityIndicator.color = UIColor.label
        } else {
            activityIndicator.color = UIColor.black
        }

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
            } else if let imageUrl = viewModel.imageUrl, let url = URL(string: imageUrl) {
                pictureView.kf.setImage(with: url)
                pictureView.isHidden = false
                pictureButton.isHidden = false
                pictureLabel.isHidden = true
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
