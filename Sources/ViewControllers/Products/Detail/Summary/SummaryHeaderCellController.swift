//
//  HeaderTableViewCellController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ImageViewer

class SummaryHeaderCell: HostedViewCell {
    // used only to specify which kind of cell we want to pass
}

class SummaryHeaderCellController: TakePictureViewController {
    var product: Product!
    var hideSummary: Bool = false

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

    @IBOutlet weak var callToActionView: PictureCallToActionView! {
        didSet {
            callToActionView?.circularProgressBar.isHidden = true
            callToActionView?.imageAddButton.isHidden = false
            callToActionView?.textLabel.isHidden = false
        }
    }

    @IBOutlet weak var scanProductSummaryView: ScanProductSummaryView!

    @IBOutlet weak var takePictureButtonView: IconButtonView! {
        didSet {
            takePictureButtonView?.circularProgressBar.isHidden = true
            takePictureButtonView?.iconImageView.isHidden = false
            takePictureButtonView?.titleLabel.isHidden = false
        }
    }

    convenience init(with product: Product, dataManager: DataManagerProtocol, hideSummary: Bool) {
        self.init(nibName: String(describing: SummaryHeaderCellController.self), bundle: nil)
        self.product = product
        self.hideSummary = hideSummary
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .front
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
        guard ImageType(imageTypeString) == .front else { return }
        if product.frontImageUrl != nil {
            replacementImageIsUploading = true
            takePictureButtonView?.circularProgressBar?.setProgress(to: progress, withAnimation: false)
            setupViews()
            self.takePictureButtonView.setNeedsLayout()
        } else {
            newImageIsUploading = true
            callToActionView?.circularProgressBar?.setProgress(to: progress, withAnimation: false)
            setupViews()
            self.callToActionView?.setNeedsLayout()
        }
    }

    fileprivate func setupViews() {
        let adaptor = ScanProductSummaryViewAdaptorFactory.makeAdaptor(from: product, delegate: self)
        scanProductSummaryView.setup(with: adaptor)

        scanProductSummaryView.isHidden = hideSummary

        takePictureButtonView.delegate = self

        if let imageUrl = product.frontImageUrl ?? product.imageUrl, URL(string: imageUrl) != nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            scanProductSummaryView.productImageView.addGestureRecognizer(tap)
            scanProductSummaryView.productImageView.isUserInteractionEnabled = true
            callToActionView.isHidden = true
            takePictureButtonView.isHidden = false
        } else {
            scanProductSummaryView.productImageView.isHidden = true
            callToActionView.isHidden = false
            takePictureButtonView.isHidden = true
            if !newImageIsUploading {
                callToActionView.textLabel.text = "call-to-action.summary".localized
                callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            }
        }
    }

        override func postImageSuccess(image: UIImage, forImageType imageType: ImageType) {
            guard super.barcode != nil else { return }
            guard imageType == .front else { return }
            if product.frontImageUrl != nil {
                replacementImageIsUploading = false
            } else {
                newImageIsUploading = false
            }
            // The ultimate owner of this viewController should do the refresh
            // Is the refresh in ProductDetailRefreshDelegate OK?
            NotificationCenter.default.post(name: .FrontImageIsUpdated, object: nil, userInfo: nil)
        }

    }

extension Notification.Name {
    static let FrontImageIsUpdated = Notification.Name("SummaryHeaderCellController.Notification.FrontImageIsUpdated")
}

// MARK: - Gesture recognizers
extension SummaryHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}

extension SummaryHeaderCellController: IconButtonViewDelegate {
    func didTap() {
        didTapTakePictureButton(callToActionView as Any)
    }
}

extension SummaryHeaderCellController: ScanProductSummaryViewProtocol {
    func scanProductSummaryViewButtonTapped(_ sender: ScanProductSummaryView, button: UIButton) {
    }
}
