//
//  Tagline.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 08/01/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

class Tagline: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var message: String = ""

    convenience init(url: String, message: String) {
        self.init()

        self.url = url
        self.message = message
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
