//
//  DataManagerClient.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 11/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

protocol DataManagerClient {
    var dataManager: DataManagerProtocol! { get set }
}
