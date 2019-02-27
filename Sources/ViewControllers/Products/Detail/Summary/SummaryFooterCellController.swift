//
//  SummaryFooterViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 27/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SummaryFooterCell: HostedViewCell {
    // used only to specify which kind of cell we want to pass
}

class SummaryFooterCellController: UIViewController, IconButtonViewDelegate {

    var product: Product!

    @IBOutlet weak var editButtonView: IconButtonView!

    convenience init(with product: Product) {
        self.init(nibName: String(describing: SummaryFooterCellController.self), bundle: nil)
        self.product = product
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditButton()
    }

    fileprivate func setupEditButton() {
        editButtonView.setImage(UIImage(named: "edit-icon")!)
        editButtonView.titleLabel.text = "product-detail.edit".localized
        editButtonView.delegate = self
    }

    func didTap() {
        if let barcode = self.product?.barcode, let url = URL(string: URLs.Edit + barcode) {
            openUrlInApp(url, showAlert: true)
        }
    }
}
