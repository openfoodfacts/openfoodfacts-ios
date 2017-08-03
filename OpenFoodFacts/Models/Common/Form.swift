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
    var sections: [FormSection]

    func getCellTypes() -> [ProductDetailBaseCell.Type] {
        var array = [ProductDetailBaseCell.Type]()

        for section in sections {
            for row in section.rows {
                array.append(row.cellType)
            }
        }

        return array
    }
}

struct FormSection {
    var rows: [FormRow]
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
