//
//  IntTransform.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 15/04/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

// The API sometimes returns a value as String and sometimes as Int, this transform handles this so we always have a Int

public class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = String

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? String, let intValue = Int(value) {
            return intValue
        } else if let value = value as? Int {
            return value
        }

        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let value = value {
            return String(value)
        }

        return nil
    }
}
