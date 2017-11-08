//
//  String.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

extension String {
    var nsrange: NSRange {
        return NSRange(location: 0, length: self.count)
    }

    func isNumber() -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\\d*$") else { return false }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

        return !matches.isEmpty
    }
}
