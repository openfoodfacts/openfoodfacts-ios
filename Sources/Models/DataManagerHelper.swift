//
//  DataManagerHelper.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 27/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

func isOffline(errorCode: Int) -> Bool {
    return errorCode == NSURLErrorNotConnectedToInternet || errorCode == NSURLErrorTimedOut
}
