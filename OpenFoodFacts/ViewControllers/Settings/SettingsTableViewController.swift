//
//  SettingsTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var scanOnLaunchSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        scanOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)
    }

    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
    }
}
