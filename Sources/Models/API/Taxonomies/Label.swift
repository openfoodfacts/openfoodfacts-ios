//
//  Label.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 8/23/20.
//

import Foundation
import RealmSwift
import ObjectMapper

class Label: Object {

    @objc dynamic var code = ""

    let parents = List<String>()
    let children = List<String>()
    let names = List<Tag>()

    @objc dynamic var mainName = "" // name in the language of the app, for sorting
    @objc dynamic var indexedNames = "" // all names concatenated, for search

    convenience init(code: String, parents: [String], children: [String], names: [Tag]) {
        self.init()
        self.code = code

        self.parents.removeAll()
        self.parents.append(objectsIn: parents)

        self.children.removeAll()
        self.children.append(objectsIn: children)

        self.names.removeAll()
        self.names.append(objectsIn: names)

        self.mainName = names.chooseForCurrentLanguage()?.value ?? ""
        self.indexedNames = names.map({ (tag) -> String in
            return tag.languageCode.appending(":").appending(tag.value)
        }).joined(separator: " ||| ") // group all names to be able to query on only one field, independently of language
    }

    override static func primaryKey() -> String? {
        return "code"
    }

    override static func indexedProperties() -> [String] {
        return ["mainName", "indexedNames"]
    }
}
