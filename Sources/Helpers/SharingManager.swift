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

    func shareLink(string: String, sender: UIBarButtonItem, presenter: UIViewController, success: ShareSuccessBlock = nil) {
        guard let link = URL(string: string) else {
            return
        }
        //let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        //sender.present(activityVC, animated: true, completion: success)

        var sharingItems = [AnyObject]()

        sharingItems.append(link as AnyObject)

        let activity = UIActivity()

        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [activity])

        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.print, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.addToReadingList]

        // This is necessary for the iPad
        let presCon = activityViewController.popoverPresentationController
        presCon?.barButtonItem = sender

        presenter.present(activityViewController, animated: true, completion: success)

    }

}
