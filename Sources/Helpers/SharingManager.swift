//
//  SharingManager.swift
//  OpenFoodFacts
//
//  Created by Егор on 2/23/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit

class SharingManager {

    static let shared = SharingManager()

    private init() {}

    typealias ShareSuccessBlock = (() -> Void)?

    func shareLink(string: String, sender: UIViewController, success: ShareSuccessBlock = nil) {
        guard let link = URL(string: string) else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        sender.present(activityVC, animated: true, completion: success)
    }

}
