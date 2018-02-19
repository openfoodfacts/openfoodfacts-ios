//
//  DeepLinkManager.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

enum DeepLinkType {
    case scan
}

class DeepLinkManager {
    static let shared = DeepLinkManager()

    private init() {}

    private var deepLink: DeepLinkType?

    @discardableResult
    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        deepLink = ShortcutParser.shared.handleShortcut(item)
        return deepLink != nil
    }

    // check existing deepling and perform action
    func checkDeepLink() {
        AppDelegate.shared.rootViewController.deepLink = deepLink

        // reset deeplink after handling
        self.deepLink = nil
    }
}
