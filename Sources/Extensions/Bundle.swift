//
//  Bundle.swift
//  OpenFoodFacts
//
//  Created by Mykola Aleshchenko on 09/05/2020.
//

import Foundation
import UIKit

extension Bundle {

    private var localizationFileName: String {
        return "Localizable.strings"
    }

    private var frameworkPath: String {
        return "Framework"
    }

    // MARK: - Determine app localization

    func appLocalizations() -> [String] {
        // For some reason, a few localization codes are not recognized as languages
        // Filtering them out: ber, me, ry, son, tzl, val

        let appLocalizations = localizations.sorted()
        let recognizedLocalizations = appLocalizations.filter {
            return NSLocale(localeIdentifier: $0).displayName(forKey: .identifier, value: $0) != nil ? true : false
        }

        return recognizedLocalizations
    }

    var currentLocalization: String {
        return UserDefaults.standard.string(forKey: UserDefaultsConstants.appLocalization) ?? String(Bundle.main.preferredLocalizations.first ?? "en")
    }

    // MARK: - Switch localization at runtime

    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let selector = #selector(swizzledLocalizedString(forKey:value:table:))
        guard let method = class_getInstanceMethod(self, selector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(method), method_getTypeEncoding(method)) {
            class_replaceMethod(self, selector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, method)
        }
    }
// See https://stackoverflow.com/questions/40859312/ios-10-camera-view-showing-api-cancel-title-instead-of-cancel/54289410#54289410

    @objc private func swizzledLocalizedString(forKey key: String, value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: currentLocalization, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.localizedString(forKey: key, value: value, table: table)
        }
        if let name = table,
            name == "CameraUI"{
         let values = NSLocalizedString(key, comment: name)

         return values
        }
        if let name = table,
            name == "PhotoLibrary"{
         let values = NSLocalizedString(key, comment: name)

         return values
        }
        if let name = table,
            name == "PhotoLibraryServices"{
         let values = NSLocalizedString(key, comment: name)

         return values
        }
        if let name = table,
            name == "PhotosUI" {
         let values = NSLocalizedString(key, comment: name)

         return values
        }

        return bundle.swizzledLocalizedString(forKey: key, value: value, table: table)
    }

}
