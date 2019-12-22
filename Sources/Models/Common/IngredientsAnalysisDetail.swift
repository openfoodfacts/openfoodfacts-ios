//
//  IngredientsAnalysisDetail.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 22/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

enum IngredientsAnalysisType: String {
    case palmOil = "from_palm_oil"
    case vegan = "vegan"
    case vegetarian = "vegetarian"
    case other = "other"
}

class IngredientsAnalysisDetail {
    var type: IngredientsAnalysisType = IngredientsAnalysisType.other
    var color: UIColor = UIColor.gray
    var icon: String = ""
}
