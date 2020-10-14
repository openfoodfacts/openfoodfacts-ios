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
    @IBOutlet weak var callToActionView: PictureCallToActionView! {
           didSet {
               callToActionView?.circularProgressBar.isHidden = true
               callToActionView?.imageAddButton.isHidden = false
               callToActionView?.textLabel.isHidden = false
           }
       }

    @IBOutlet weak var takePictureButtonView: IconButtonView! {
        didSet {
            takePictureButtonView?.circularProgressBar.isHidden = true
            takePictureButtonView?.iconImageView.isHidden = false
            takePictureButtonView?.titleLabel.isHidden = false
        }
    }

    @IBOutlet weak var novaStackView: UIStackView!
    @IBOutlet weak var novagroupView: NovaGroupView!
    @IBOutlet weak var novagroupExplanationLabel: UILabel! {
        didSet {
            novagroupExplanationLabel?.text = "product-detail.ingredients.nova.incite".localized
            novagroupExplanationLabel?.sizeToFit()
        }
    }
    @IBOutlet weak var novagroupInfoButton: UIButton! {
        didSet {
            if #available(iOS 13.0, *) {
                novagroupInfoButton.setImage(UIImage.init(systemName: "info.circle"), for: .normal)
            } else {
                novagroupInfoButton.setImage(UIImage.init(named: "circle-info"), for: .normal)
            }
        }
    }

    @IBAction func novagroupInfoButtonTapped(_ sender: UIButton) {
        if let url = URL(string: URLs.Nova) {
            openUrlInApp(url)
        } else if let url = URL(string: URLs.SupportOpenFoodFacts) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        guard ImageType(imageTypeString) == .ingredients else { return }
        if product.ingredientsImageUrl != nil {
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
            callToActionView?.isHidden = true
            takePictureButtonView?.isHidden = false
        } else {
            ingredients.isHidden = true
            callToActionView.isHidden = false
            takePictureButtonView.isHidden = true
            if !newImageIsUploading {
                callToActionView.textLabel.text = "call-to-action.ingredients".localized
                callToActionView.addGestureRecognizer( UITapGestureRecognizer( target: self, action: #selector(didTapTakePictureButton(_:))))
            }
        }
        if let novaGroupValue = product.novaGroup,
            let novaGroup = NovaGroupView.NovaGroup(rawValue: "\(novaGroupValue)") {
            setNovaGroup(novaGroup: novaGroup)
        } else {
            setNovaGroup(novaGroup: nil)
        }
    }

    private func setNovaGroup(novaGroup: NovaGroupView.NovaGroup?) {
        if let novaGroup = novaGroup {
            novagroupView?.novaGroup = novaGroup
            switch novaGroup {
            case .one:
                novagroupExplanationLabel?.text = "product-detail.ingredients.nova.1".localized
            case .two:
                novagroupExplanationLabel?.text = "product-detail.ingredients.nova.2".localized
            case .three:
                novagroupExplanationLabel?.text = "product-detail.ingredients.nova.3".localized
            case .four:
                novagroupExplanationLabel?.text = "product-detail.ingredients.nova.4".localized
            }
            novagroupView?.isHidden = false
        } else {
            novagroupExplanationLabel?.text = "product-detail.ingredients.nova.incite".localized
            novagroupView?.isHidden = true
        }
    }

    override func postImageSuccess(image: UIImage, forImageType imageType: ImageType) {
        guard super.barcode != nil else { return }
        guard imageType == .ingredients else { return }
        if product.ingredientsImageUrl != nil {
            replacementImageIsUploading = false
        } else {
            newImageIsUploading = false
        }
        // Notification is used by FormTableViewController
        NotificationCenter.default.post(name: .IngredientsImageIsUpdated, object: nil, userInfo: nil)
    }

}

extension Notification.Name {
        static let IngredientsImageIsUpdated = Notification.Name("IngredientsHeaderCellController.Notification.IngredientsImageIsUpdated")
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
        didTapTakePictureButton(callToActionView as Any)
    }
}
