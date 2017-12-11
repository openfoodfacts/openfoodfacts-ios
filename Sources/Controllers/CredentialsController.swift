//
//  CredentialsController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 15/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import KeychainAccess
import Crashlytics

class CredentialsController: NSObject {
    static let shared = CredentialsController()

    // Keychain access
    private static let serviceIdentifier = "org.openfoodfacts.openfoodfacts"
    let keychain = Keychain(service: serviceIdentifier)

    // UserDefaults
    private let usernameKey = "username"
    private let defaults = UserDefaults.standard

    func getUsername() -> String? {
        return defaults.string(forKey: usernameKey)
    }

    func clearCredentials() {
        guard let username = getUsername() else { return }
        defaults.removeObject(forKey: usernameKey)
        do {
            try keychain.remove(username)
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    func saveCredentials(username: String, password: String) {
        keychain[username] = password
        defaults.set(username, forKey: usernameKey)
    }

    func getCredentials() -> (username: String, password: String)? {
        guard let username = getUsername() else { return nil }

        if let password = keychain[username] {
            return (username, password)
        } else {
            return nil
        }
    }
}
