//
//  ProductAttributes.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on 9/29/20.
//
import ObjectMapper

/**
 A model for Products usinig the [Product Attributes api](https://wiki.openfoodfacts.org/Product_Attributes)
 */
struct ProductAttributes {
    var barcode: String?
    var attributeGroups: [AttributeGroup]?

    init?(map: Map) {
        barcode <- map[ProductAttributesJson.BarcodeKey]
        attributeGroups <- map["\(OFFJson.ProductKey + "." + ProductAttributesJson.attributeGroupsLang())"]
        // Fail init if some basic values are not present
        if self.barcode == nil && self.attributeGroups == nil {
            return nil
        }
    }
}

struct AttributeGroup: Mappable {
    var id: String?
    var name: String?
    var attributes: [Attribute]?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map[AttributeGroupJson.id]
        name <- map[AttributeGroupJson.NameKey]
        attributes <- map[AttributeGroupJson.AttributesKey]
    }
}

struct Attribute: Mappable {
    var id: String?
    var name: String?
    var status: String?
    var match: Double?
    var iconUrl: String?
    var title: String?
    var details: String?
    var descriptionShort: String?
    var descriptionLong: String?
    var recommendationShort: String?
    var recommendationLong: String?
    var officialLinkTitle: String?
    var officialLinkUrl: String?
    var offLinkTitle: String?
    var offLinkUrl: String?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map[AttributeJson.IDKey]
        name <- map[AttributeJson.NameKey]
        status <- map[AttributeJson.StatusKey]
        match <- (map[AttributeJson.MatchKey], DoubleTransform())
        iconUrl <- map[AttributeJson.IconUrlKey]
        title <- map[AttributeJson.TitleKey]
        details <- map[AttributeJson.DetailsKey]
        descriptionShort <- map[AttributeJson.DescriptionShortKey]
        descriptionLong <- map[AttributeJson.DescriptionLongKey]
        recommendationShort <- map[AttributeJson.RecommendationShortKey]
        recommendationLong <- map[AttributeJson.RecommendationLongKey]
        officialLinkTitle <- map[AttributeJson.OfficialLinkTitleKey]
        officialLinkUrl <- map[AttributeJson.OfficialLinkUrlKey]
        offLinkTitle <- map[AttributeJson.OffLinkTitleKey]
        offLinkUrl <- map[AttributeJson.OffLinkUrlKey]
    }
}
