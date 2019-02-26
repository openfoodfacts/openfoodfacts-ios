//
//  TagTransform.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 03/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

public class Tag: Object {
    @objc dynamic var languageCode: String = ""
    @objc dynamic var value: String = ""

    public convenience init(languageCode: String, value: String) {
        self.init()
        self.languageCode = languageCode
        self.value = value
    }

    /// choose the most appropriate tags based on the language passed in parameters, default to english if not found
    static func choose(inTags tags: [Tag], forLanguageCode languageCode: String? = nil, defaultToFirst: Bool = false) -> Tag? {
        let lang = languageCode ?? Bundle.main.preferredLocalizations.first ?? "en"

        if let tag = tags.first(where: { (tag: Tag) -> Bool in
            return tag.languageCode == lang
        }) {
            return tag
        }

        if lang != "en" {
            return choose(inTags: tags, forLanguageCode: "en")
        }

        if defaultToFirst {
            return tags.first
        }

        return nil
    }
}

extension Array where Element: Tag {
    func chooseForCurrentLanguage(defaultToFirst: Bool = false) -> Tag? {
        return Tag.choose(inTags: self, forLanguageCode: nil, defaultToFirst: defaultToFirst)
    }
}

extension List where Element: Tag {
    func chooseForCurrentLanguage(defaultToFirst: Bool = false) -> Tag? {
        return Array(self).chooseForCurrentLanguage(defaultToFirst: defaultToFirst)
    }
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
