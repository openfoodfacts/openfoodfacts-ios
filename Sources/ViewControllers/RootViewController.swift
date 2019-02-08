//
//  RootViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private var tabBarVC: UITabBarController
    private var tabBarNotificationController: TabBarNotificationController

    var deepLink: DeepLinkType? {
        didSet {
            handleDeepLink()
        }
    }

    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let tabBarVC = storyboard.instantiateInitialViewController() as? UITabBarController else { fatalError("Initial VC is required") }
        self.tabBarVC = tabBarVC
        self.tabBarNotificationController = TabBarNotificationController(tabBarController: tabBarVC)

        super.init(nibName: nil, bundle: nil)

        // Inject dependencies
        let productApi = ProductService()
        let persistenceManager = PersistenceManager()

        let taxonomiesApi = TaxonomiesService()
        taxonomiesApi.persistenceManager = persistenceManager
        taxonomiesApi.refreshTaxonomiesFromServerIfNeeded()

        let dataManager = DataManager()
        dataManager.productApi = productApi
        dataManager.taxonomiesApi = taxonomiesApi
        dataManager.persistenceManager = persistenceManager

        setupViewControllers(tabBarVC, dataManager)

        transition(to: tabBarVC) { _ in
            let count = dataManager.getItemsPendingUpload().count
            NotificationCenter.default.post(name: .pendingUploadBadgeChange, object: nil, userInfo: [NotificationUserInfoKey.pendingUploadItemCount: count])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Inject dependencies into tab view controllers
    ///
    /// - Parameters:
    ///   - productApi: API Client
    ///   - dataManager: Local store client
    private func setupViewControllers(_ tab: UITabBarController, _ dataManager: DataManager) {
        for (index, child) in tab.viewControllers?.enumerated() ?? [].enumerated() {
            if var top = child as? DataManagerClient {
                top.dataManager = dataManager
            }

            if child is UserViewController, let item = tab.tabBar.items?[index] {
                let items = dataManager.getItemsPendingUpload()
                item.badgeValue = items.isEmpty ? nil : "\(items.count)"
            }
        }
    }

    private func showScan() {
        for child in tabBarVC.viewControllers ?? [] {
            if let searchVC = child as? SearchViewController {
                searchVC.scanBarcode()
                break
            }
        }
    }

    private func handleDeepLink() {
        guard let deepLink = self.deepLink else { return }

        switch deepLink {
        case .scan:
            showScan()
        }

        // Reset
        self.deepLink = nil
    }
}
