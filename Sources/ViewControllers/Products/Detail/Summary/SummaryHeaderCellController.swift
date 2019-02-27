//
//  HeaderTableViewCellController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ImageViewer

class SummaryHeaderCellController: TakePictureViewController {
    var product: Product!

    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var scanProductSummaryView: ScanProductSummaryView!

    @IBOutlet weak var takePictureButtonView: IconButtonView!
    @IBOutlet weak var editButton: UIButton!

    convenience init(with product: Product, dataManager: DataManagerProtocol) {
        self.init(nibName: String(describing: SummaryHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .front
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        self.scanProductSummaryView.fillIn(product: product)

        takePictureButtonView.delegate = self

        if let imageUrl = product.frontImageUrl ?? product.imageUrl, URL(string: imageUrl) != nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            scanProductSummaryView.productImageView.addGestureRecognizer(tap)
            scanProductSummaryView.productImageView.isUserInteractionEnabled = true
            callToActionView.isHidden = true
            takePictureButtonView.isHidden = false
        } else {
            scanProductSummaryView.productImageView.isHidden = true
            callToActionView.textLabel.text = "call-to-action.summary".localized
            callToActionView.isHidden = false
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            takePictureButtonView.isHidden = true
        }

        setupEditButton()
    }

    fileprivate func setupEditButton() {
        let editButtonTitleString = Bundle(identifier: "com.apple.UIKit")?.localizedString(forKey: "Edit", value: "Edit", table: nil)
        editButton.setTitle(editButtonTitleString, for: .normal)
        editButton.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
    }

}

// MARK: - Gesture recognizers
extension SummaryHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }

    @objc func didTapEditButton(_ sender: UIButton) {
        if let barcode = self.product?.barcode, let url = URL(string: URLs.Edit + barcode) {
            openUrlInApp(url, showAlert: true)
        }
    }
}

extension SummaryHeaderCellController: IconButtonViewDelegate {
    func didTap() {
        didTapTakePictureButton(callToActionView)
    }
}
