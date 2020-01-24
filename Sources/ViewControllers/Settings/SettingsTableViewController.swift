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
    @IBOutlet weak var scanOnLaunchSwitch: UISwitch!
    @IBOutlet weak var disableDisplayVegetarianStatusSwitch: UISwitch!
    @IBOutlet weak var disableDisplayVeganStatusSwitch: UISwitch!
    @IBOutlet weak var disableDisplayPalmOilnStatusSwitch: UISwitch!

    var dataManager: DataManagerProtocol!

    private let allergensAlertsIndexPath = IndexPath(row: 2, section: 0)

    private let frequentlyAskedQuestionsIndexPath = IndexPath(row: 0, section: 1)

    private let discoverIndexPath = IndexPath(row: 1, section: 1)
    private let howToContributeIndexPath = IndexPath(row: 0, section: 2)
    private let supportOpenFoodFactsIndexPath = IndexPath(row: 1, section: 2)
    private let translateOpenFoodFactsIndexPath = IndexPath(row: 2, section: 2)
    private let contactTheTeamIndexPath = IndexPath(row: 1, section: 3)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "settings.tab-bar.item".localized
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scanOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsConstants.scanningOnLaunch)

        disableDisplayPalmOilnStatusSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayPalmOilStatus)
        disableDisplayVegetarianStatusSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayVegetarianStatus)
        disableDisplayVeganStatusSwitch.isOn = !UserDefaults.standard.bool(forKey: UserDefaultsConstants.disableDisplayVeganStatus)
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
        switch indexPath {
        case discoverIndexPath:
            url = URL(string: URLs.Discover)
        case howToContributeIndexPath:
            url = URL(string: URLs.HowToContribute)
        case supportOpenFoodFactsIndexPath:
            urlsupport = URL(string: URLs.SupportOpenFoodFacts)
        case translateOpenFoodFactsIndexPath:
            url = URL(string: URLs.TranslateOpenFoodFacts)
        case contactTheTeamIndexPath:
            contactTheTeam()
        case frequentlyAskedQuestionsIndexPath:
            url = URL(string: URLs.FrequentlyAskedQuestions)
        case allergensAlertsIndexPath:
            openAllergensAlerts()
        default:
            break
        }
        if let url = url {
            openUrlInApp(url)
        } else if let url = urlsupport {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? UserViewController {
            destVC.dataManager = self.dataManager
        }
    }

    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        if sender == scanOnLaunchSwitch {
            UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
        } else if sender == disableDisplayPalmOilnStatusSwitch {
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayPalmOilStatus)
        } else if sender == disableDisplayVegetarianStatusSwitch {
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayVegetarianStatus)
        } else if sender == disableDisplayVeganStatusSwitch {
            UserDefaults.standard.set(!sender.isOn, forKey: UserDefaultsConstants.disableDisplayVeganStatus)
        }
    }
    fileprivate func openAllergensAlerts() {
        let alertsVC = AllergensAlertsTableViewController()
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
