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
    @IBOutlet weak var progressBar: CircularProgressBar!

    override func awakeFromNib() {
        pictureView.contentMode = .scaleAspectFit
    }

    func configure(viewModel: PictureViewModel) {

        if viewModel.isUploading {
            progressBar.isHidden = false
            pictureView.isHidden = true
            pictureButton.isHidden = true
            pictureLabel.isHidden = true

            if let validProgress = viewModel.uploadProgress {
                progressBar.setProgress(to: validProgress, withAnimation: false)
            }
        } else {
            progressBar.isHidden = true
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
        }
    }
}
