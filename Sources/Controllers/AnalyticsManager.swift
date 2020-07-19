//
//  AnalyticsService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 14/06/2020.
//

import UIKit
import Sentry
import BLTNBoard
import Foundation
import MatomoTracker

class AnalyticsManager {

    //TODO: config
    let sharedMatomoTracker: MatomoTracker = MatomoTracker(
        siteId: "1",
        baseURL: URL(string: "https://example.com/piwik.php")!
    )

    // as sentry cannot be enabled or disabled at runtime, we store the enabled status at startup. Changing the value requires an app restart to be taken into account
    fileprivate var isCrashReportingEnabledAtStartup: Bool

    private init() {
        sharedMatomoTracker.isOptedOut = !AnalyticsManager.isAnalyticsReportingEnabled()
        isCrashReportingEnabledAtStartup = AnalyticsManager.isCrashReportingEnabled()
    }

    func start() {
        if isCrashReportingEnabledAtStartup {
            SentrySDK.start(options: [
                "dsn": "https://6d047aa6fcff4c788d7e8db147eef179@o241488.ingest.sentry.io/5276492",
                "debug": false, // Enabled debug when first installing is always helpful
                "enableAutoSessionTracking": true
            ])
        }
    }

    static let shared = AnalyticsManager()

    func log(_ value: String, forKey key: String) {
        if isCrashReportingEnabledAtStartup {
            SentrySDK.configureScope { (scope: Scope) in
                scope.setTag(value: value, key: key)
            }
        }
    }

    func record(error: Error, withAdditionalUserInfo: [String: String]? = nil) {
        if isCrashReportingEnabledAtStartup {
            SentrySDK.capture(error: error) { (scope: Scope) in
                if let withAdditionalUserInfo = withAdditionalUserInfo {
                    scope.setTags(withAdditionalUserInfo)
                }
            }
        }
    }

    func track(view: View) {
        sharedMatomoTracker.track(view: view.path)
        log(view.path.joined(separator: "/"), forKey: "current-screen")
    }

    func track(event: Event) {
        sharedMatomoTracker.track(eventWithCategory: event.category, action: event.action, name: event.name, value: event.value)
    }

    func trackSearch(query: String, resultsCount: Int?) {
        sharedMatomoTracker.trackSearch(query: query, category: nil, resultCount: resultsCount)
    }

    static func isCrashReportingEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: UserDefaultsConstants.privacySettingsCrashReportingEnabled) != nil {
            return UserDefaults.standard.bool(forKey: UserDefaultsConstants.privacySettingsCrashReportingEnabled)
        }
        // crash reporting defaults to yes
        return true
    }

    static func setIsCrashReporting(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: UserDefaultsConstants.privacySettingsCrashReportingEnabled)
    }

    lazy var bulletinManager: BLTNItemManager = {
        let page = BLTNPageItem(title: "settings.privacy.analytics.title".localized)
        page.isDismissable = false
        page.descriptionText = "settings.privacy.analytics.bulletin.description".localized
        page.actionButtonTitle = "settings.privacy.analytics.bulletin.accept".localized
        page.alternativeButtonTitle = "settings.privacy.analytics.bulletin.refuse".localized

        page.actionHandler = { [weak self] item in
            self?.setIsAnalyticsReporting(enabled: true)
            item.manager?.dismissBulletin()
        }
        page.alternativeHandler = { [weak self] item in
            self?.setIsAnalyticsReporting(enabled: false)
            item.manager?.dismissBulletin()
        }

        let bulletinManager = BLTNItemManager(rootItem: page)
        return bulletinManager
    }()

    func showAnalyticsBulletinBoardIfNeeded(above: UIViewController) {
        if UserDefaults.standard.object(forKey: UserDefaultsConstants.privacySettingsAnalyticsEnabled) != nil {
            return
        }
        bulletinManager.showBulletin(above: above)
    }

    static func isAnalyticsReportingEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: UserDefaultsConstants.privacySettingsAnalyticsEnabled) != nil {
            return UserDefaults.standard.bool(forKey: UserDefaultsConstants.privacySettingsAnalyticsEnabled)
        }
        // analytics defaults to false
        return false
    }

    func setIsAnalyticsReporting(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: UserDefaultsConstants.privacySettingsAnalyticsEnabled)
        sharedMatomoTracker.isOptedOut = !enabled
    }
}
