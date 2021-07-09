//
//  AttributeTableRow.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 11/6/20.
//

import Foundation

struct AttributeTableRow {
    weak var delegate: AttributeTableViewCellDelegate?
    let attribute: Attribute?

    init(_ delegate: AttributeTableViewCellDelegate?, attribute: Attribute?) {
        self.delegate = delegate
        self.attribute = attribute
    }
}
