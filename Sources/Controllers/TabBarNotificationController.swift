//
//  TabBarNotificationController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let pendingUploadBadgeChange = Notification.Name("pending-upload-change")
}

struct NotificationUserInfoKey {
    static let pendingUploadItemCount = "pending-upload-item-count"
}

class TabBarNotificationController {
    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController

        NotificationCenter.default.addObserver(self, selector: #selector(self.pendingUploadBadgeChange(_:)), name: .pendingUploadBadgeChange, object: nil)
    }

    @objc func pendingUploadBadgeChange(_ notification: NSNotification) {
        guard let count = notification.userInfo?[NotificationUserInfoKey.pendingUploadItemCount] as? Int else { return }
        guard let index = getTabBarItemIndexForTitle("user.tab-bar.item".localized) else { return }
        self.tabBarController.tabBar.items?[index].badgeValue = count == 0 ? nil : "\(count)" // swiftlint:disable:this empty_count
        UIApplication.shared.applicationIconBadgeNumber = count
        log.debug("Updated PendingUpload badge with value \(count)")
    }

    private func getTabBarItemIndexForTitle(_ title: String) -> Int? {
        guard let items = self.tabBarController.tabBar.items else { return nil }
        for (index, item) in items.enumerated() where item.title == title {
            return index
        }

        return nil
    }
}
