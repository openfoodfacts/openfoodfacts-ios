//
//  PendingUploadItem.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class PendingUploadItem: Object {
    @objc dynamic var barcode = ""
    @objc dynamic var productName: String?
    @objc dynamic var brand: String?
    @objc dynamic var quantity: String?
    @objc dynamic var language = "en"
    @objc dynamic var frontUrl = ""
    @objc dynamic var ingredientsUrl = ""
    @objc dynamic var nutritionUrl = ""

    var frontImage: UIImage?
    var ingredientsImage: UIImage?
    var nutritionImage: UIImage?

    override static func primaryKey() -> String? {
        return "barcode"
    }
}
