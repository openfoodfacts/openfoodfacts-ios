//
//  RealmOfflineProduct.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 05/03/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

class RealmOfflineProduct: Object {

    @objc dynamic var barcode = ""
    @objc dynamic var name: String?
    @objc dynamic var quantity: String?
    @objc dynamic var brands: String?
    @objc dynamic var nutritionGrade: String?
    @objc dynamic var novaGroup: String?

    override static func primaryKey() -> String? {
        return "barcode"
    }
}
