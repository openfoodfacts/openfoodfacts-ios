//
//  UserDefaultsConstants.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

struct UserDefaultsConstants {
    static let scanningOnLaunch = "scanningOnLaunch"
    static let disableDisplayIngredientAnalysisStatus = { (type: String) -> String in return "disableDisplayAnalysisStatus_" + type}
    static let disableRobotoffWhenNotLoggedIn = "disableRobotoffWhenNotLoggedIn"
    static let appLocalization = "appLocalization"
}
