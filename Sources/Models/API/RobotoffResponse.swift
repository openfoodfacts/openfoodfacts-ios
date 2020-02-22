//
//  RobotoffResponse.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 19/02/2020.
//  Copyright © 2020 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ObjectMapper

class RobotoffQuestion: Mappable {
    var barcode = ""
    var type = ""
    var value = ""
    var question = ""
    var insightId = ""
    var insightType = ""
    var sourceImageUrl = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        barcode <- map[OFFJson.BarcodeKey]
        type <- map[OFFJson.TypeKey]
        value <- map[OFFJson.ValueKey]
        question <- map[OFFJson.QuestionKey]
        insightId <- map[OFFJson.InsightIdKey]
        insightType <- map[OFFJson.InsightTypeKey]
        sourceImageUrl <- map[OFFJson.SourceImageUrlKey]
    }
}

class RobotoffResponse: Mappable {
    var questions = [RobotoffQuestion]()

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        questions <- map[OFFJson.QuestionsKey]
    }
}
