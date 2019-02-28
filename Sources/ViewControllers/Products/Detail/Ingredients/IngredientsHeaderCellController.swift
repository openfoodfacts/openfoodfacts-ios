//
//  IngredientsHeaderCellController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 05/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ImageViewer

class IngredientsHeaderCellController: TakePictureViewController {
    var product: Product!
    @IBOutlet weak var ingredients: UIImageView!
    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var takePictureButtonView: IconButtonView!

    weak var delegate: FormTableViewControllerDelegate?

    convenience init(with product: Product, dataManager: DataManagerProtocol) {
        self.init(nibName: String(describing: IngredientsHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .ingredients
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        self.takePictureButtonView.delegate = self

        if let imageUrl = product.ingredientsImageUrl, let url = URL(string: imageUrl) {
            ingredients.kf.indicatorType = .activity
            ingredients.kf.setImage(with: url, options: nil) { result in
                switch result {
                case .success(let value):
                    // When the image is not cached in memory, call delegate method to handle the cell's size change
                    if value.cacheType != .memory {
                        self.delegate?.cellSizeDidChange()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            ingredients.addGestureRecognizer(tap)
            ingredients.isUserInteractionEnabled = true
            callToActionView.isHidden = true
            takePictureButtonView.isHidden = false
        } else {
            ingredients.isHidden = true
            callToActionView.isHidden = false
            callToActionView.textLabel.text = "call-to-action.ingredients".localized
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            takePictureButtonView.isHidden = true
        }
    }
}

// MARK: - Gesture recognizers
extension IngredientsHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}

extension IngredientsHeaderCellController: IconButtonViewDelegate {
    func didTap() {
        didTapTakePictureButton(callToActionView)
    }
}
