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

    @IBOutlet weak var editButtonView: IconButtonView! {
        didSet {
            editButtonView?.circularProgressBar.isHidden = true
        }
    }

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
            guard let loginVC = UserViewController.loadFromStoryboard(named: .settings) as? UserViewController else {
                return }
            loginVC.dataManager = dataManager
            //loginVC.delegate = self

            let navVC = UINavigationController(rootViewController: loginVC)
            loginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(SummaryFooterCellController.dismissVC))
            loginVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(SummaryFooterCellController.dismissVC))

            self.present(navVC, animated: true)

            return
        }

        if let product = self.product {
            let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
            if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
                addProductVC.productToEdit = product
                addProductVC.dataManager = dataManager

                let navVC = UINavigationController(rootViewController: addProductVC)
                if self.responds(to: #selector(SummaryFooterCellController.dismissVC)) {
                    addProductVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(SummaryFooterCellController.dismissVC))
                }
                if addProductVC.responds(to: #selector(ProductAddViewController.saveAll)) {
                    addProductVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: addProductVC, action: #selector(ProductAddViewController.saveAll))
                }
                navVC.modalPresentationStyle = .fullScreen

                self.present(navVC, animated: true)
            }
        }
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
//
//extension SummaryFooterCellController: UserViewControllerDelegate {
//    func dismiss() {
//        setupInterface()
//    }
//}
