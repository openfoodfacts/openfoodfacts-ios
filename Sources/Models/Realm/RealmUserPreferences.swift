//
//  RealmUserPreferences.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 24/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift

class RealmOfflineProductStatus: Object {
    @objc dynamic var percent: Double = 0
    @objc dynamic var savedProductsCount: Int = 0
}

class RealmUserPreferences: Object {

    @objc dynamic var offlineStatus: RealmOfflineProductStatus? = RealmOfflineProductStatus()

    let allergens = List<Allergen>()

}
