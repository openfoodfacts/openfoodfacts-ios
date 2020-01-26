//
//  IngredientsAnalysisDetail.swift
//  OpenFoodFacts
//
//  Created by Timothee MATO on 22/12/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class IngredientsAnalysisDetail {
    var type: String = ""
    var color: UIColor = UIColor.gray
    var icon: String = ""
    var title: String = ""
    var tag: String = ""

    /// name of type (vegan, vegetarian, palm oil" translated in the user language
    var typeDisplayName: String?
    var showIngredientsTag: String?
}
