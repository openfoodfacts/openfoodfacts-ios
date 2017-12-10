//
//  SearchViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func showProductDetails(product: Product)
}

class SearchViewController: UIViewController, ProductApiClient {
    var productApi: ProductApi!
    var rootNavigationController: UINavigationController!

    override func viewDidLoad() {
        if self.rootNavigationController == nil {
            self.rootNavigationController = UINavigationController(rootViewController: createSearchTableVC())
            transition(to: self.rootNavigationController)
        }
    }

    private func createScanButton() -> UIBarButtonItem {
        let scanButton = UIBarButtonItem(image: UIImage(named: "barcode"), style: .plain, target: self, action: #selector(scanBarcode(_:)))
        scanButton.accessibilityIdentifier = AccessibilityIdentifiers.scanButton
        return scanButton
    }

    private func createSearchTableVC() -> SearchTableViewController {
        let searchTableVC = SearchTableViewController.loadFromStoryboard() as SearchTableViewController
        searchTableVC.productApi = productApi
        searchTableVC.delegate = self
        searchTableVC.navigationItem.rightBarButtonItems = [createScanButton()]
        return searchTableVC
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    func showProductDetails(product: Product) {
        let productDetailsVC = ProductDetailViewController.loadFromStoryboard() as ProductDetailViewController
        productDetailsVC.product = product
        productDetailsVC.productApi = productApi
        productDetailsVC.navigationItem.rightBarButtonItems = [createScanButton()]

        self.rootNavigationController.pushViewController(productDetailsVC, animated: true)
    }

    @objc func scanBarcode(_ sender: UIBarButtonItem) {
        let scanVC = ScannerViewController(productApi: productApi)
        self.rootNavigationController.pushViewController(scanVC, animated: true)
    }
}
