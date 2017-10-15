//
//  CredentialsControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 15/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble
import KeychainAccess

// swiftlint:disable force_try
class CredentialsControllerTests: XCTestCase {
    var controller: CredentialsController!

    let userDefaultsUsernameKey = "username"
    static let keychainServiceIdentifier = "org.openfoodfacts.openfoodfacts"
    let keychain = Keychain(service: keychainServiceIdentifier)
    let testUser = "test_user"
    let testPassword = "test_password"

    override func setUp() {
        controller = CredentialsController()

        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key == userDefaultsUsernameKey, let username = value as? String {

                try! keychain.remove(username)
            }

            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    func testGetUsernameShouldReturnUsername() {
        UserDefaults.standard.set(testUser, forKey: userDefaultsUsernameKey)

        let result = controller.getUsername()

        expect(result).to(equal(testUser))
    }

    func testGetUsernameShouldNotReturnUsername() {
        let result = controller.getUsername()

        expect(result).to(beNil())
    }

    func testClearCredentials() {
        UserDefaults.standard.set(testUser, forKey: userDefaultsUsernameKey)
        keychain[testUser] = testPassword

        controller.clearCredentials()

        expect(UserDefaults.standard.string(forKey: self.userDefaultsUsernameKey)).to(beNil())
        expect(try! self.keychain.contains(self.testUser)).to(beFalse())
    }

    func testClearCredentialsDoesNothingWhenUsernameNotInUserDefaults() {
        keychain[testUser] = testPassword

        controller.clearCredentials()

        expect(UserDefaults.standard.string(forKey: self.userDefaultsUsernameKey)).to(beNil())
        expect(try! self.keychain.contains(self.testUser)).to(beTrue())
    }

    func testSaveCredentials() {
        controller.saveCredentials(username: testUser, password: testPassword)

        expect(UserDefaults.standard.string(forKey: self.userDefaultsUsernameKey)).to(equal(testUser))
        expect(self.keychain[self.testUser]).to(equal(testPassword))
    }

    func testGetCredentials() {
        UserDefaults.standard.set(testUser, forKey: userDefaultsUsernameKey)
        keychain[testUser] = testPassword

        let result = controller.getCredentials()

        expect(result!.username).to(equal(testUser))
        expect(result!.password).to(equal(testPassword))
    }

    func testGetCredentialsReturnsNilWhenUsernameNotInUserDefaults() {
        keychain[testUser] = testPassword

        let result = controller.getCredentials()

        expect(result).to(beNil())
    }

    func testGetCredentialsReturnsNilWhenCredentialsNotInKeychain() {
        UserDefaults.standard.set(testUser, forKey: userDefaultsUsernameKey)

        let result = controller.getCredentials()

        expect(result).to(beNil())
    }
}
