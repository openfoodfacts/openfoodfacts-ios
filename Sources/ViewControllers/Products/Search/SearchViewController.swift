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

extension SearchViewController: SearchViewControllerDelegate, HistoryTableViewControllerDelegate {

    func showProductDetails(product: Product) {
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
