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

    private let discoverIndexPath = IndexPath(row: 1, section: 1)
    private let howToContributeIndexPath = IndexPath(row: 2, section: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        scanOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "settings.tab-bar.item".localized
        } else if section == 1 {
            return "settings.sections.information".localized
        } else {
            return ""
        }
    }

    @IBAction func didTapOpenBeautyFacts(_ sender: UIButton) {
        guard let url = URL(string: URLs.OpenBeautyFacts) else { return }
        UIApplication.shared.openURL(url)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url: URL?
        switch indexPath {
        case discoverIndexPath:
            url = URL(string: URLs.Discover)
        case howToContributeIndexPath:
            url = URL(string: URLs.HowToContribute)
        default:
            break
        }

        if let url = url {
            openUrlInApp(url)
        }
    }

    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
    }
}
