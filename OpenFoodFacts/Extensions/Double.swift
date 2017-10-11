//
//  Double.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

extension Double {
    var twoDecimalRounded: Double {
        return (self * 100).rounded() / 100
    }

    var asTwoDecimalRoundedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(value: self)) ?? ""
    }
}
