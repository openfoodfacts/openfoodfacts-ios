//
//  IngredientsAnalysis.swift
//  OpenFoodFacts
//
//  Created by matotim on 02/10/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class IngredientsAnalysis: Object {
    @objc dynamic var code = ""
    @objc dynamic var showIngredientsTag: String?

    let names = List<Tag>()

    @objc dynamic var mainName = "" // name in the language of the app, for sorting
    @objc dynamic var indexedNames = "" // all names concatenated, for search

    convenience init(code: String, names: [Tag], showIngredientsTag: String?) {
        self.init()
        self.code = code
        self.showIngredientsTag = showIngredientsTag

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
