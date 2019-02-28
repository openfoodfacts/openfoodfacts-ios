//
//  NutritionTableHeaderCellController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ImageViewer

class NutritionTableHeaderCellController: TakePictureViewController {
    var product: Product!
    @IBOutlet weak var nutritionTableImage: UIImageView!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var takePictureButtonView: IconButtonView!

    weak var delegate: FormTableViewControllerDelegate?

    convenience init(with product: Product, dataManager: DataManagerProtocol) {
        self.init(nibName: String(describing: NutritionTableHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .nutrition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        self.imageHeightConstraint?.constant = 30
        self.takePictureButtonView.delegate = self

        if let imageUrl = product.nutritionTableImage, let url = URL(string: imageUrl) {
            nutritionTableImage.kf.indicatorType = .activity

            nutritionTableImage.kf.setImage(with: url, options: nil) { result in
                switch result {
                case .success(let value):
                    self.imageHeightConstraint?.constant = min(value.image.size.height, 130)
                    // When the image is not cached in memory, call delegate method to handle the cell's size change
                    if value.cacheType != .memory {
                        self.delegate?.cellSizeDidChange()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            nutritionTableImage.addGestureRecognizer(tap)
            nutritionTableImage.isUserInteractionEnabled = true
            callToActionView.isHidden = true
            takePictureButtonView.isHidden = false
        } else {
            nutritionTableImage.isHidden = true
            callToActionView.isHidden = false
            callToActionView.textLabel.text = "call-to-action.nutrition".localized
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            takePictureButtonView.isHidden = true
        }

        if let servingSize = product.servingSize {
            servingSizeLabel.text = "\("product-detail.nutrition-table.for-serving".localized): \(servingSize)"
        }
    }
}

// MARK: - Gesture recognizers
extension NutritionTableHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}

extension NutritionTableHeaderCellController: IconButtonViewDelegate {
    func didTap() {
        didTapTakePictureButton(callToActionView)
    }
}
