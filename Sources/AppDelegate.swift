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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureRealm()

        if ProcessInfo().environment["UITesting"] == nil {
            configureLog()
            Fabric.with([Crashlytics.self])
        } else {
            UIApplication.shared.keyWindow?.layer.speed = 100
        }

        ShortcutParser.shared.registerShortcuts()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DeepLinkManager.shared.checkDeepLink()
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(DeepLinkManager.shared.handleShortcut(item: shortcutItem))
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

    private func configureRealm() {
        // https://stackoverflow.com/questions/33363508/rlmexception-migration-is-required-for-object-type
        let config = Realm.Configuration(
            schemaVersion: 31,
          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { _, oldSchemaVersion in
            // Whenever your scheme changes your have to increase the schemaVersion in the migration block and update the needed migration within the block.
            if oldSchemaVersion < 31 {
              // Nothing to do!
              // Realm will automatically detect new properties and removed properties
              // And will update the schema on disk automatically
            }
          })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        do {
            _ = try Realm(configuration: config)
            print("AppDelegate: Database Path : \(config.fileURL!)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

// swiftlint:disable force_cast
extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}
