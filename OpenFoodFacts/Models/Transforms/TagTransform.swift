//
//  TagTransform.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Tag {
    let languageCode: String
    let value: String
}

public class TagTransform: TransformType {
    public typealias Object = [Tag]
    public typealias JSON = [String]
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let tagList = value as? [String] {
            var tags = [Tag]()
            for tag in tagList {
                let split = tag.components(separatedBy: ":")
                tags.append(Tag(languageCode: split[0], value: split[1]))
            }
            
            return tags
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let tags = value {
            var tagList = [String]()
            for tag in tags {
                tagList.append("\(tag.languageCode):\(tag.value)")
            }
            
            return tagList
        }
        
        return nil
    }
}
