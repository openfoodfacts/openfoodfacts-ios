//
//  ShortcutParser.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

enum ShortcutKey: String {
    case scan = "org.openfoodfacts.org.scan"
}

class ShortcutParser {
    static let shared = ShortcutParser()

    private init() { }

    func registerShortcuts() {
        let scanIcon = UIApplicationShortcutIcon(templateImageName: "barcode")
        let scanShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.scan.rawValue, localizedTitle: "shortcuts.scan".localized, localizedSubtitle: nil, icon: scanIcon, userInfo: nil)

        UIApplication.shared.shortcutItems = [scanShortcutItem]
    }

    func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> DeepLinkType? {
        switch shortcut.type {
        case ShortcutKey.scan.rawValue:
            return  .scan
        default:
            return nil
        }
    }
}
