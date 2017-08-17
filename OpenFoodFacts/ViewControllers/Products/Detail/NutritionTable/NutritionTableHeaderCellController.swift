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

    weak var delegate: FormTableViewControllerDelegate?

    convenience init(with product: Product, productApi: ProductApi) {
        self.init(nibName: String(describing: NutritionTableHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.productApi = productApi
        super.imageType = .nutrition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        self.imageHeightConstraint?.constant = 30

        if let imageUrl = product.nutritionTableImage, let url = URL(string: imageUrl) {
            nutritionTableImage.kf.indicatorType = .activity
            nutritionTableImage.kf.setImage(with: url, options: [.processor(RotatingProcessor())]) { (image, _, cacheType, _) in
                if let image = image {
                    self.imageHeightConstraint?.constant = min(image.size.height, 130)
                }

                // When the image is not cached in memory, call delegate method to handle the cell's size change
                if cacheType != .memory {
                    self.delegate?.cellSizeDidChange()
                }
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            nutritionTableImage.addGestureRecognizer(tap)
            nutritionTableImage.isUserInteractionEnabled = true
        } else {
            nutritionTableImage.isHidden = true
            callToActionView.isHidden = false
            callToActionView.textLabel.text = NSLocalizedString("call-to-action.nutrition", comment: "")
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
        }

        if let servingSize = product.servingSize {
            servingSizeLabel.text = "\(NSLocalizedString("product-detail.nutrition-table.for-serving", comment: "")): \(servingSize)"
        }
    }
}

// MARK: - Gesture recognizers
extension NutritionTableHeaderCellController {
    func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}
