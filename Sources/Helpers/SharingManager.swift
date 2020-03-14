//
//  SharingManager.swift
//  OpenFoodFacts
//
//  Created by Егор on 2/23/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit

final class SharingManager {

    static let shared = SharingManager()

    private init() {}

    typealias ShareSuccessBlock = (() -> Void)?

    func shareLink(name: String?, string: String, sender: UIBarButtonItem, presenter: UIViewController, success: ShareSuccessBlock = nil) {

        var sharingItems = [AnyObject]()

        if let link = URL(string: string) {
            sharingItems.append(link as AnyObject)
        }

        if let productName = name {
            sharingItems.append(productName as AnyObject)
        }

        let activity = UIActivity()

        let safariActivity = SafariActivity()

        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [activity, safariActivity])

        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.print, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.addToReadingList]

        // This is necessary for the iPad
        let presCon = activityViewController.popoverPresentationController
        presCon?.barButtonItem = sender

        presenter.present(activityViewController, animated: true, completion: success)

    }

}

extension UIActivity.ActivityType {
    static let openInSafari = UIActivity.ActivityType(rawValue: "openInSafari")
}

final class SafariActivity: UIActivity {

    var url: URL?

    var activityCategory: UIActivity.Category = .action

    override var activityType: UIActivity.ActivityType {
        .openInSafari
    }

    override var activityTitle: String? {
        "Open in Safari"
    }

    override var activityImage: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "safari")?.applyingSymbolConfiguration(.init(scale: .large))
        } else {
            // Fallback on earlier versions
            return nil
        }
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if let validURL = item as? URL {
                if UIApplication.shared.canOpenURL(validURL) {
                    return true
                }
            }
        }
        return false
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let validURL = item as? URL {
                if UIApplication.shared.canOpenURL(validURL) {
                    url = validURL
                    return
                }
            }
        }
        url = nil
    }

    override func perform() {
        if let url = url {
            UIApplication.shared.open(url)
        }
        self.activityDidFinish(true)
    }

}
