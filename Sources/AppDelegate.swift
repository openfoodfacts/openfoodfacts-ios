//
//  AppDelegate.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import XCGLogger
import RealmSwift

let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        configureRealm()

        if ProcessInfo().environment["UITesting"] == nil {
            configureLog()
            Fabric.with([Crashlytics.self])
        } else {
            UIApplication.shared.keyWindow?.layer.speed = 100
        }

        // Inject dependencies
        let dataManager = DataManager()
        let productApi = ProductService()

        setupViewControllers(productApi, dataManager)

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "scan" {

            // Instantiate main vc
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateInitialViewController()
            window?.rootViewController = rootVC

            // Inject dependencies
            let dataManager = DataManager()
            let productApi = ProductService()

            setupViewControllers(productApi, dataManager)

            // Display scan vc
            let scanVC = ScannerViewController(productApi: productApi)
            if let tab = window?.rootViewController as? UITabBarController {
                for child in tab.viewControllers ?? [] {
                    if let navController = child as? UINavigationController, let vc = navController.topViewController as? SearchTableViewController {
                        vc.navigationController?.pushViewController(scanVC, animated: false)
                    }
                }
            }
        }
    }

    fileprivate func configureLog() {
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        log.add(destination: systemDestination)
        log.logAppDetails()

    }

    /// Inject dependencies into tab view controllers
    ///
    /// - Parameters:
    ///   - productApi: API Client
    ///   - dataManager: Local store client
    fileprivate func setupViewControllers(_ productApi: ProductApi, _ dataManager: DataManager) {
        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if var top = child as? ProductApiClient {
                    top.productApi = productApi
                }

                if var top = child as? DataManagerClient {
                    top.dataManager = dataManager
                }
            }
        }
    }

    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1/*,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
        }*/)

        Realm.Configuration.defaultConfiguration = config
    }
}
