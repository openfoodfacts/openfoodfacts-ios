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
    private let howToContributeIndexPath = IndexPath(row: 0, section: 2)
    private let supportOpenFoodFactsIndexPath = IndexPath(row: 1, section: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        scanOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "settings.tab-bar.item".localized
        } else if section == 1 {
            return "settings.sections.information".localized
        } else if section == 2 {
            return "settings.sections.contribute".localized
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
        var urlsupport: URL?
        switch indexPath {
        case discoverIndexPath:
            url = URL(string: URLs.Discover)
        case howToContributeIndexPath:
            url = URL(string: URLs.HowToContribute)
        case supportOpenFoodFactsIndexPath:
            urlsupport = URL(string: URLs.SupportOpenFoodFacts)
        default:
            break
        }

        if let url = url {
            openUrlInApp(url)
        } else if let url = urlsupport {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
    }
}
