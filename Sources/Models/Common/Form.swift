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
    var separator: String = ", "

    init(label: String? = nil, value: Any, cellType: ProductDetailBaseCell.Type, isCopiable: Bool = false, separator: String = ", ") {
        self.label = label
        self.value = value
        self.cellType = cellType
        self.isCopiable = isCopiable
        self.separator = separator
    }

    func getValueAsString() -> String? {
        if let value = value as? String {
            return value
        } else if let value = value as? [String] {
            return value.joined(separator: separator)
        }

        return nil
    }

    func getValueAsAttributedString() -> NSAttributedString? {
        if let value = value as? NSAttributedString {
            return value
        } else if let value = value as? [NSAttributedString] {
            return value.reduce(into: NSMutableAttributedString(), { ( result: inout NSMutableAttributedString, attributedString: NSAttributedString) in
                if result.length > 0 {
                    result.append(NSAttributedString(string: separator))
                }
                result.append(attributedString)
            })
        }
        if let value = getValueAsString() {
            return NSAttributedString(string: value)
        }
        return nil
    }
}
