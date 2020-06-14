//
//  AnalyticsService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 14/06/2020.
//

import Foundation

class AnalyticsManager {

    static func log(_ value: String, forKey key: String) {
        //TODO:
    }

    static func logEvent() {
        //TODO:
    }

    static func record(error: Error, withAdditionalUserInfo: [String: String]? = nil) {
        //TODO: send it to sentry
    }

}
