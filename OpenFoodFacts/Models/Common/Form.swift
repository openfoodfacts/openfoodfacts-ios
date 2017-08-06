//
//  Form.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct Form {
    var title: String
    var rows: [FormRow]

    func getCellTypes() -> [ProductDetailBaseCell.Type] {
        var array = [ProductDetailBaseCell.Type]()
        var identifiers = Set<String>()

        for row in rows {
            if !identifiers.contains(row.cellType.identifier) {
                identifiers.insert(row.cellType.identifier)
                array.append(row.cellType)
            }
        }

        return array
    }
}

struct FormRow {
    var label: String?
    var value: Any
    var cellType: ProductDetailBaseCell.Type

    init(label: String? = nil, value: Any, cellType: ProductDetailBaseCell.Type) {
        self.label = label
        self.value = value
        self.cellType = cellType
    }
}
