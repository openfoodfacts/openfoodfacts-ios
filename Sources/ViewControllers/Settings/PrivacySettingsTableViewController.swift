//
//  PrivacySettingsViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 19/07/2020.
//

import UIKit

class PrivacySettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDescriptionLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    var type: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellSwitch.addTarget(self, action: #selector(changeSwitch(sender:)), for: .valueChanged)
    }

    @objc func changeSwitch(sender: UISwitch) {
        if type == "crash" {
            AnalyticsManager.setIsCrashReporting(enabled: sender.isOn)
        } else if type == "analytics" {
            AnalyticsManager.shared.setIsAnalyticsReporting(enabled: sender.isOn)
        }
    }
}

class PrivacySettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "settings.privacy.title".localized
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "privacySettingsCellIdentifier") as? PrivacySettingsTableViewCell else {
            fatalError("The cell is missing. No cell, no table.")
        }

        if indexPath.row == 0 {
            cell.cellTitleLabel.text = "settings.privacy.crash.title".localized
            cell.cellDescriptionLabel.text = "settings.privacy.crash.description".localized
            cell.cellSwitch.isOn = AnalyticsManager.isCrashReportingEnabled()
            cell.type = "crash"
        } else if indexPath.row == 1 {
            cell.cellTitleLabel.text = "settings.privacy.analytics.title".localized
            cell.cellDescriptionLabel.text = "settings.privacy.analytics.description".localized
            cell.cellSwitch.isOn = AnalyticsManager.isAnalyticsReportingEnabled()
            cell.type = "analytics"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
