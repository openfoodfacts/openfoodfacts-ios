//
//  SettingsTableViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

// swiftlint:disable force_cast
class SettingsTableViewControllerTests: XCTestCase {
    var viewController: SettingsTableViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Settings", bundle: Bundle.main)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navController.topViewController as! SettingsTableViewController

        UIApplication.shared.keyWindow!.rootViewController = viewController

        expect(self.viewController.view).notTo(beNil())

        TestHelper.sharedInstance.clearUserDefaults()
    }

    // MARK: - viewDidLoad
    func testViewDidLoadShouldTurnScanOnLaunchSwitchOnWhenSettingIsTrue() {
        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.scanningOnLaunch)

        viewController.viewDidLoad()

        expect(self.viewController.scanOnLaunchSwitch.isOn).to(beTrue())
    }

    func testViewDidLoadShouldNotTurnScanOnLaunchSwitchOnWhenSettingIsFalse() {
        viewController.viewDidLoad()

        expect(self.viewController.scanOnLaunchSwitch.isOn).to(beFalse())
    }

    // MARK: - didSwitchScanOnLaunch
    func testDidSwitchScanOnLaunchShouldUpdateSettingToTrueWhenSwitchedOn() {
        let scanOnLaunchSwitch = UISwitch()
        scanOnLaunchSwitch.isOn = true

        viewController.didSwitchScanOnLaunch(scanOnLaunchSwitch)

        expect(UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)).to(beTrue())
    }

    func testDidSwitchScanOnLaunchShouldUpdateSettingToFalseWhenSwitchedOff() {
        let scanOnLaunchSwitch = UISwitch()
        scanOnLaunchSwitch.isOn = false

        viewController.didSwitchScanOnLaunch(scanOnLaunchSwitch)

        expect(UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)).to(beFalse())
    }
}
