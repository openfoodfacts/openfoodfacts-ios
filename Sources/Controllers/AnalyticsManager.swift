//
//  AnalyticsService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 14/06/2020.
//

import Foundation
import Sentry

class AnalyticsManager {

    static func log(_ value: String, forKey key: String) {
        SentrySDK.configureScope { (scope: Scope) in
            scope.setTag(value: value, key: key)
        }
    }

    static func record(error: Error, withAdditionalUserInfo: [String: String]? = nil) {
        SentrySDK.capture(error: error) { (scope: Scope) in
            if let withAdditionalUserInfo = withAdditionalUserInfo {
                scope.setTags(withAdditionalUserInfo)
            }
        }
    }

}
