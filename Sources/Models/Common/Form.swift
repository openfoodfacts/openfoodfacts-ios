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
    let isCopiable: Bool

    init(label: String? = nil, value: Any, cellType: ProductDetailBaseCell.Type, isCopiable: Bool = false) {
        self.label = label
        self.value = value
        self.cellType = cellType
        self.isCopiable = isCopiable
    }

    func getValueAsString() -> String? {
        if let value = value as? String {
            return value
        } else if let value = value as? [String] {
            //check to see if value contains a bullet \u{2022}. For example, addtivies in the ingredients form uses bullet list so commas are no longer necessary. Therefore the String array conversion needs to not include commas in this case. https://github.com/openfoodfacts/openfoodfacts-ios/issues/60
            if value[0].range(of:"\u{2022}") != nil {
                return value.joined(separator: "")
            } else {
            return value.joined(separator: ", ")
            }
            
        }

        return nil
    }
}
