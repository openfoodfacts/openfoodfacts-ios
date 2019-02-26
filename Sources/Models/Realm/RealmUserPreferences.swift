//
//  RealmUserPreferences.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserPreferences: Object {

    let allergens = List<Allergen>()

}
