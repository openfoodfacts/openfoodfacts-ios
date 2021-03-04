//
//  EnvironmentHeaderCellController.swift
//  OpenFoodFacts
//
//  Created by arnaud on 21/11/2020.
//

import UIKit
import ImageViewer

class EnvironmentHeaderCellController: TakePictureViewController {

    var product: Product!

    @IBOutlet weak var packaging: UIImageView!

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

    @IBOutlet weak var ecoscoreImageView: EcoscoreImageView! {
        didSet {
            ecoscoreImageView.isHidden = false
        }
    }

    @IBOutlet weak var ecoscoreExplanationLabel: UILabel! {
        didSet {
            ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.incite".localized
            ecoscoreExplanationLabel?.sizeToFit()
        }
    }
    @IBOutlet weak var ecoscoreInfoButton: UIButton! {
        didSet {
            if #available(iOS 13.0, *) {
                ecoscoreInfoButton.setImage(UIImage.init(systemName: "info.circle"), for: .normal)
            } else {
                ecoscoreInfoButton.setImage(UIImage.init(named: "circle-info"), for: .normal)
            }
        }
    }

    @IBOutlet weak var ecoScoreView: EcoscoreImageView!

    @IBAction func ecoscoreInfoButtonTapped(_ sender: UIButton) {
        if let url = URL(string: URLs.Ecoscore) {
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
        self.init(nibName: String(describing: EnvironmentHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .packaging
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
        guard ImageType(imageTypeString) == .packaging else { return }
        if product.packagingImageUrl != nil {
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

        if let imageUrl = product.packagingImageUrl, let url = URL(string: imageUrl) {
            packaging.kf.indicatorType = .activity
            packaging.kf.setImage(with: url, options: nil) { result in
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
            packaging.addGestureRecognizer(tap)
            packaging.isUserInteractionEnabled = true
            callToActionView?.isHidden = true
            takePictureButtonView?.isHidden = false
        } else {
            packaging.isHidden = true
            callToActionView.isHidden = false
            takePictureButtonView.isHidden = true
            if !newImageIsUploading {
                callToActionView.textLabel.text = "call-to-action.environment".localized
                callToActionView.addGestureRecognizer( UITapGestureRecognizer( target: self, action: #selector(didTapTakePictureButton(_:))))
            }
        }

        if let ecoscoreValue = product.ecoscore,
            let ecoscore = EcoscoreImageView.Ecoscore(rawValue: "\(ecoscoreValue)") {
            setEcoscore(ecoscore: ecoscore)
        } else {
            setEcoscore(ecoscore: .unknown)
        }

    }

    private func setEcoscore(ecoscore: EcoscoreImageView.Ecoscore?) {
            if let validEcoscore = ecoscore {
                ecoscoreImageView?.ecoScore = validEcoscore
                switch validEcoscore {
                case .ecoscoreA:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.a".localized
                case .ecoscoreB:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.b".localized
                case .ecoscoreC:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.c".localized
                case .ecoscoreD:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.d".localized
                case .ecoscoreE:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.e".localized
                case .unknown:
                    ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.unknown".localized
                }
        } else {
                ecoscoreImageView?.ecoScore = .unknown
            ecoscoreExplanationLabel?.text = "product-detail.environment.ecoscore.incite".localized
        }
    }

    override func postImageSuccess(image: UIImage, forImageType imageType: ImageType) {
        guard super.barcode != nil else { return }
        guard imageType == .packaging else { return }
        if product.packagingImageUrl != nil {
            replacementImageIsUploading = false
        } else {
            newImageIsUploading = false
        }
        // Notification is used by FormTableViewController
        NotificationCenter.default.post(name: .PackagingImageIsUpdated, object: nil, userInfo: nil)
    }

}

extension Notification.Name {
    static let PackagingImageIsUpdated = Notification.Name("EnvironmentHeaderCellController.Notification.PackagingImageIsUpdated")
}

// MARK: - Gesture recognizers

extension EnvironmentHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}

extension EnvironmentHeaderCellController: IconButtonViewDelegate {
    func didTap() {
        didTapTakePictureButton(callToActionView as Any)
    }
}
