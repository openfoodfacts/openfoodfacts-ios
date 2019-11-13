//
//  SearchViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SearchViewControllerDelegate: class {
    func showProductDetails(product: Product)
}

class SearchViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    var rootNavigationController: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "product-search.title".localized

        if self.rootNavigationController == nil {
            self.rootNavigationController = UINavigationController(rootViewController: createSearchTableVC())
            transition(to: self.rootNavigationController)
        }
    }

    private func createSearchTableVC() -> SearchTableViewController {
        let searchTableVC = SearchTableViewController.loadFromStoryboard(named: .search) as SearchTableViewController
        searchTableVC.dataManager = dataManager
        searchTableVC.delegate = self
        return searchTableVC
    }
}

extension SearchViewController: SearchViewControllerDelegate {

    func showProductDetails(product: Product) {
        guard let barcode = product.barcode else { return }
        //fetching full product to have all needed data
        SVProgressHUD.show()
        dataManager.getProduct(byBarcode: barcode, isScanning: false, isSummary: false, onSuccess: { fetchedProduct in
            if let product = fetchedProduct {
                self.presentProductDetails(product: product)
            }
            SVProgressHUD.dismiss()
        }, onError: { _ in
            SVProgressHUD.dismiss()
        })
    }

    private func presentProductDetails(product: Product) {
        let productDetailsVC = ProductDetailViewController.loadFromStoryboard() as ProductDetailViewController
        productDetailsVC.product = product
        productDetailsVC.dataManager = dataManager

        // Store product in search history
        dataManager.addHistoryItem(product)

        self.rootNavigationController.pushViewController(productDetailsVC, animated: true)
    }

    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
}
