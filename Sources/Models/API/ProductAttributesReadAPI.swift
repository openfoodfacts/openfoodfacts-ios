//
//  ProductAttributesAPIkeysJSON.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 9/29/20.
//

import Foundation

// MARK: - ProductAttributes keys
struct ProductAttributesJson {
    static let BarcodeKey = "code"
    static let AttributeGroupsKey = "attribute_groups"

    static func attributeGroupsLang() -> String {
        let langCode = Bundle.main.currentLocalization
        // language code is expected to be 2 char long
        if langCode.count == 2 {
            return AttributeGroupsKey + "_" + langCode
        }
        return AttributeGroupsKey
    }
}

// MARK: - AttributeGroup keys
struct AttributeGroupJson {
    static let id = "id"
    static let NameKey = "name"
    static let AttributesKey = "attributes"
}

// MARK: - Attribute keys
struct AttributeJson {
    static let IDKey = "id"
    static let NameKey = "name"
    static let StatusKey = "status"
    static let MatchKey = "match"
    static let IconUrlKey = "icon_url"
    static let TitleKey = "title"
    static let DetailsKey = "details"
    static let DescriptionShortKey = "description_short"
    static let DescriptionLongKey = "description"
    static let RecommendationShortKey = "recommendation_short"
    static let RecommendationLongKey = "recommendation_long"
    static let OfficialLinkTitleKey = "official_link_title"
    static let OfficialLinkUrlKey = "official_link_url"
    static let OffLinkTitleKey = "off_link_title"
    static let OffLinkUrlKey = "off_link_url"
}
