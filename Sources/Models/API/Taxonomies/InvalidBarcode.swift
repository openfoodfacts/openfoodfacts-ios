//
//  RealmInvalidBarcode.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 09/01/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

class InvalidBarcode: Object {

    @objc dynamic var barcode = ""

    public convenience init(barcode: String) {
        self.init()
        self.barcode = barcode
    }

    override static func primaryKey() -> String? {
        return "barcode"
    }
}
