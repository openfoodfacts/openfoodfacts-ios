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

    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var scanProductSummaryView: ScanProductSummaryView!

    @IBOutlet weak var takePictureButtonView: IconButtonView!

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

    fileprivate func setupViews() {
        scanProductSummaryView.fillIn(product: product)

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
            callToActionView.textLabel.text = "call-to-action.summary".localized
            callToActionView.isHidden = false
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            takePictureButtonView.isHidden = true
        }
    }
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
        didTapTakePictureButton(callToActionView)
    }
}
