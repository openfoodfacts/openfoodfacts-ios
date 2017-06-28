//
//  DoubleTransform.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 10/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

// The API sometimes returns a value as String and sometimes as Double, this transform handles this so we always have a Double

public class DoubleTransform: TransformType {
    public typealias Object = Double
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? String, let doubleValue = Double(value) {
            return doubleValue
        } else if let value = value as? Double {
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
