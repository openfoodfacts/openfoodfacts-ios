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

    @IBOutlet weak var novaStackView: UIStackView!
    @IBOutlet weak var novagroupView: NovaGroupView!
    @IBOutlet weak var novagroupExplanationLabel: UILabel! {
        didSet {
            novagroupExplanationLabel?.text = "product-detail.ingredients.nova.incite".localized
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
            novagroupView?.isHidden = false
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
        didTapTakePictureButton(callToActionView as Any)
    }
}
