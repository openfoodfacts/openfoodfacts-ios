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
    var dataManager: DataManagerProtocol!

    @IBOutlet weak var editButtonView: IconButtonView!

    convenience init(with product: Product, dataManager: DataManagerProtocol) {
        self.init(nibName: String(describing: SummaryFooterCellController.self), bundle: nil)
        self.product = product
        self.dataManager = dataManager
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
        if CredentialsController.shared.getUsername() == nil {
            let loginVC = LoginViewController.loadFromStoryboard(named: .user) as LoginViewController
            loginVC.dataManager = dataManager
            loginVC.delegate = self

            let navVC = UINavigationController(rootViewController: loginVC)
            loginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(SummaryFooterCellController.dismissLoginVC))

            self.present(navVC, animated: true)

            return
        }

        if let barcode = self.product?.barcode, let url = URL(string: URLs.Edit + barcode) {
            openUrlInApp(url, showAlert: true)
        }
    }

    @objc func dismissLoginVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension SummaryFooterCellController: UserViewControllerDelegate {
    func dismiss() {
        dismissLoginVC()
    }

    func showProductsPendingUpload() {
    }
}
