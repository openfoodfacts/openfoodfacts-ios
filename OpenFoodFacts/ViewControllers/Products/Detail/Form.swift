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
    // TODO: Should we loop sections to get all cell types? Need this for registering the cells with the tableview
    var cellTypes: [ProductDetailBaseCell.Type]
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
