//
//  Allergen.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/02/2019.
//

import Foundation
import RealmSwift
import ObjectMapper

class Category: Object {

    @objc dynamic var code = ""

    let parents = List<String>()
    let children = List<String>()
    let names = List<Tag>()

    convenience init(code: String, parents: [String], children: [String], names: [Tag]) {
        self.init()
        self.code = code

        self.parents.removeAll()
        self.parents.append(objectsIn: parents)

        self.children.removeAll()
        self.children.append(objectsIn: children)

        self.names.removeAll()
        self.names.append(objectsIn: names)
    }

    override static func primaryKey() -> String? {
        return "code"
    }
}
