//
//  IngredientsAnalysisConfig.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 16/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class IngredientsAnalysisConfig: Object {
    @objc dynamic var code = ""
    @objc dynamic var type = ""
    @objc dynamic var icon = ""
    @objc dynamic var color = ""

    convenience init(code: String, type: String, icon: String, color: String) {
        self.init()

        self.code = code
        self.type = type
        self.icon = icon
        self.color = color
    }

    override static func primaryKey() -> String? {
        return "code"
    }
}
