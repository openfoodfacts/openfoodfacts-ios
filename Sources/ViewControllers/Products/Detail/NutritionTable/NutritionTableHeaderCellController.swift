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

    @IBOutlet weak var callToActionView: PictureCallToActionView! {
           didSet {
               callToActionView?.circularProgressBar?.isHidden = true
               callToActionView?.imageAddButton?.isHidden = false
               callToActionView?.textLabel?.isHidden = false
           }
       }

    @IBOutlet weak var takePictureButtonView: IconButtonView! {
           didSet {
               takePictureButtonView?.circularProgressBar?.isHidden = true
               takePictureButtonView?.iconImageView?.isHidden = false
               takePictureButtonView?.titleLabel?.isHidden = false
           }
       }

    weak var delegate: FormTableViewControllerDelegate?

    private var newImageIsUploading = false {
        didSet {
            callToActionView?.circularProgressBar.isHidden = !newImageIsUploading
            callToActionView?.imageAddButton.isHidden = newImageIsUploading
            callToActionView?.textLabel.isHidden = newImageIsUploading
        }
    }

    private var replacementImageIsUploading = false {
        didSet {
            takePictureButtonView?.circularProgressBar.isHidden = !replacementImageIsUploading
            takePictureButtonView?.iconImageView.isHidden = replacementImageIsUploading
            takePictureButtonView?.titleLabel.isHidden = replacementImageIsUploading
        }
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imageUploadProgress(_:)), name: .imageUploadProgress, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: .imageUploadProgress, object: nil)
    }

    @objc func imageUploadProgress(_ notification: NSNotification) {
        guard let validBarcode = product?.barcode else { return }
        guard let barcode = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadBarcodeString] as? String else { return }
        guard validBarcode == barcode else { return }
        // guard let languageCode = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadLanguageString] as? String else { return }
        guard let progress = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadFractionDouble] as? Double else { return }
        guard let imageTypeString = notification.userInfo?[ProductService.NotificationUserInfoKey.ImageUploadTypeString] as? String else { return }
        guard ImageType(imageTypeString) == .nutrition else { return }

        if product.nutritionTableImage != nil {
            replacementImageIsUploading = true
            takePictureButtonView?.circularProgressBar?.setProgress(to: progress, withAnimation: false)
            setupViews()
            self.takePictureButtonView.setNeedsLayout()
        } else {
            newImageIsUploading = true
            callToActionView?.circularProgressBar?.setProgress(to: progress, withAnimation: false)
            setupViews()
            self.callToActionView.setNeedsLayout()
        }
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
            callToActionView?.isHidden = true
            takePictureButtonView?.isHidden = false
        } else {
            nutritionTableImage.isHidden = true
            callToActionView?.isHidden = false
            takePictureButtonView?.isHidden = true
            if !newImageIsUploading {
                callToActionView?.textLabel.text = "call-to-action.nutrition".localized
                callToActionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            }
        }

        if let servingSize = product.servingSize {
            servingSizeLabel.text = "\("product-detail.nutrition-table.for-serving".localized): \(servingSize)"
        }
    }

    override func postImageSuccess(image: UIImage, forImageType imageType: ImageType) {
        guard super.barcode != nil else { return }
        guard imageType == .nutrition else { return }
        if product.nutritionTableImage != nil {
            replacementImageIsUploading = false
        } else {
            newImageIsUploading = false
        }
        // Notification is used by FormTableViewController
        NotificationCenter.default.post(name: .NutritionImageIsUpdated, object: nil, userInfo: nil)
    }

}

extension Notification.Name {
    static let NutritionImageIsUpdated = Notification.Name("NutritionTableHeaderCellController.Notification.NutritionImageIsUpdated")
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
        didTapTakePictureButton(callToActionView as Any)
    }
}
