//
//  SettingsTableViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 19/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MessageUI

enum SettingsSection: Int {
    case item
    case information
    case contribute
    case about
}

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, DataManagerClient {
    @IBOutlet weak var displayRobotoffSwitch: UISwitch!
    @IBOutlet weak var scanOnLaunchSwitch: UISwitch!

    @IBOutlet weak var userProfileCell: UITableViewCell!
    @IBOutlet weak var languageCell: UITableViewCell!
    @IBOutlet weak var allergenAlertCell: UITableViewCell!
    @IBOutlet weak var ingredientAnalysisAlertCell: UITableViewCell!

    @IBOutlet weak var frequentlyAskedQuestionsCell: UITableViewCell!
    @IBOutlet weak var discoverCell: UITableViewCell!

    @IBOutlet weak var contributeCell: UITableViewCell!
    @IBOutlet weak var supportOffCell: UITableViewCell!
    @IBOutlet weak var translateOffCell: UITableViewCell!

    @IBOutlet weak var creditsCell: UITableViewCell!
    @IBOutlet weak var contactCell: UITableViewCell!

    var dataManager: DataManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "settings.tab-bar.item".localized
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayRobotoffSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableRobotoffWhenNotLoggedIn)
        scanOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let settings = SettingsSection(rawValue: section) else { return "" }
        switch settings {
        case .item:
            return "settings.tab-bar.item".localized
        case .information:
            return "settings.sections.discover".localized
        case .contribute:
            return "settings.sections.contribute".localized
        case .about:
            return "settings.sections.about".localized
        }
    }
    @IBAction func didTapOpenBeautyFacts(_ sender: UIButton) {
        guard let url = URL(string: URLs.OpenBeautyFacts) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url: URL?
        var urlsupport: URL?

        if let selectedCell = tableView.cellForRow(at: indexPath) {
            switch selectedCell {
            case languageCell:
                navigationController?.pushViewController(LanguagesTableViewController(), animated: true)
            case discoverCell:
                url = URL(string: URLs.Discover)
            case contributeCell:
                url = URL(string: URLs.HowToContribute)
            case supportOffCell:
                urlsupport = URL(string: URLs.SupportOpenFoodFacts)
            case translateOffCell:
                url = URL(string: URLs.TranslateOpenFoodFacts)
            case contactCell:
                contactTheTeam()
            case frequentlyAskedQuestionsCell:
                url = URL(string: URLs.FrequentlyAskedQuestions)
            case allergenAlertCell:
                openAllergensAlerts()
            case ingredientAnalysisAlertCell:
                openIngredientsAnalysisAlerts()
            default:
                break
            }
        }
        if let url = url {
            openUrlInApp(url)
        } else if let url = urlsupport {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? UserViewController {
            destVC.dataManager = self.dataManager
        }
    }

    @IBAction func didSwitchDisplayRobotoff(_ sender: UISwitch) {
        if sender == displayRobotoffSwitch {
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableRobotoffWhenNotLoggedIn)
        }
    }
    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        if sender == scanOnLaunchSwitch {
            UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
        }
    }
    fileprivate func openAllergensAlerts() {
        let alertsVC = AllergensAlertsTableViewController()
        alertsVC.dataManager = dataManager
        self.navigationController?.pushViewController(alertsVC, animated: true)
    }
    fileprivate func openIngredientsAnalysisAlerts() {
        let alertsVC = IngredientsAnalysisSettingsTableViewController()
        alertsVC.dataManager = dataManager
        self.navigationController?.pushViewController(alertsVC, animated: true)
    }
    func contactTheTeam() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        mailComposerViewController.setToRecipients(["contact@openfoodfacts.org"])
        mailComposerViewController.setSubject("Open Food Facts: ")
        mailComposerViewController.setMessageBody("", isHTML: false)
        return mailComposerViewController
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
