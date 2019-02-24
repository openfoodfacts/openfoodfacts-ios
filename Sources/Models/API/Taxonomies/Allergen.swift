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

    @objc dynamic var mainName = "" // name in the language of the app, for sorting
    @objc dynamic var indexedNames = "" // all names concatenated, for search

    convenience init(code: String, names: [Tag]) {
        self.init()
        self.code = code

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
