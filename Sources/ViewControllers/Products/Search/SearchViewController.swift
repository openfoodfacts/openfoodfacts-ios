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

class SearchViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
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

    private func createHistoryButton() -> UIBarButtonItem {
        let historyButton = UIBarButtonItem(image: UIImage(named: "navbar-button-history"), style: .plain, target: self, action: #selector(showHistory(_:)))
        historyButton.accessibilityIdentifier = AccessibilityIdentifiers.historyButton
        return historyButton
    }

    private func createSearchTableVC() -> SearchTableViewController {
        let searchTableVC = SearchTableViewController.loadFromStoryboard(named: .search) as SearchTableViewController
        searchTableVC.dataManager = dataManager
        searchTableVC.delegate = self
        searchTableVC.navigationItem.rightBarButtonItems = [createScanButton(), createHistoryButton()]
        return searchTableVC
    }
}

extension SearchViewController: SearchViewControllerDelegate, HistoryTableViewControllerDelegate {

    func showProductDetails(product: Product) {
        let productDetailsVC = ProductDetailViewController.loadFromStoryboard() as ProductDetailViewController
        productDetailsVC.product = product
        productDetailsVC.dataManager = dataManager
        productDetailsVC.navigationItem.rightBarButtonItems = [createScanButton()]

        // Store product in search history
        dataManager.addHistoryItem(product)

        self.rootNavigationController.pushViewController(productDetailsVC, animated: true)
    }

    @objc func scanBarcode(_ sender: UIBarButtonItem) {
        scanBarcode()
    }

    func scanBarcode() {
        let scanVC = ScannerViewController(dataManager: dataManager)

        let navVC = UINavigationController(rootViewController: scanVC)
        navVC.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "generic.back".localized, style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissAnimated))

        self.present(navVC, animated: true, completion: nil)
    }

    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func showHistory(_ sender: UIBarButtonItem) {
        let historyVC = HistoryTableViewController.loadFromStoryboard(named: .search) as HistoryTableViewController
        historyVC.dataManager = dataManager
        historyVC.delegate = self

        self.rootNavigationController.pushViewController(historyVC, animated: true)
    }

    func showItem(_ item: HistoryItem, onError: @escaping () -> Void) {
        dataManager.getProduct(byBarcode: item.barcode, isScanning: false, isSummary: false, onSuccess: { product in
            if let product = product {
                self.showProductDetails(product: product)
            } else {
                onError()
            }
        }, onError: { _ in
            onError()
        })
    }
}
