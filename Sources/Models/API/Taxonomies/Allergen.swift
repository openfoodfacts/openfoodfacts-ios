//
//  Allergen.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/02/2019.
//

import Foundation
import RealmSwift
import ObjectMapper

class Allergen: Object {

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
