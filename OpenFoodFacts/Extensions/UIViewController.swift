//
//  UIViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SafariServices
import NotificationBanner

extension UIViewController {
    func openUrlInApp(_ url: URL, showAlert: Bool? = nil) {
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(vc, animated: true)

        if showAlert == true {
            NotificationBanner(title: "product-detail.edit-alert.title".localized,
                               subtitle: "product-detail.edit-alert.subtitle".localized,
                               style: .warning).show()
        }
    }
}
