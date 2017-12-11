//
//  Array.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 24/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

extension Array {
    public mutating func append(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
}
