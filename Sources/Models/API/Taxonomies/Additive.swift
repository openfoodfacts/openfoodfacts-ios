//
//  Additive.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Additive: Object {

    @objc dynamic var code = ""
    let names = List<Tag>()

    convenience init(code: String, names: [Tag]) {
        self.init()
        self.code = code
        self.names.removeAll()
        self.names.append(objectsIn: names)
    }

    override static func primaryKey() -> String? {
        return "code"
    }
}
