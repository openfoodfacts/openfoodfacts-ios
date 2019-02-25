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

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var scanOnLaunchSwitch: UISwitch!

    private let discoverIndexPath = IndexPath(row: 1, section: 1)
    private let howToContributeIndexPath = IndexPath(row: 0, section: 2)
    private let supportOpenFoodFactsIndexPath = IndexPath(row: 1, section: 2)
    private let translateOpenFoodFactsIndexPath = IndexPath(row: 2, section: 2)
    private let contactTheTeamIndexPath = IndexPath(row: 1, section: 3)
    private let frequentlyAskedQuestionsIndexPath = IndexPath(row: 0, section: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "settings.tab-bar.item".localized

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
        default:
            break
        }

        if let url = url {
            openUrlInApp(url)
        } else if let url = urlsupport {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func didSwitchScanOnLaunch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstants.scanningOnLaunch)
    }

    func contactTheTeam() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }

    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients(["contact@openfoodfacts.org"])
        composeVC.setSubject("Open Food Facts: ")
        composeVC.setMessageBody("Thank you for contacting us.", isHTML: false)

        self.present(composeVC, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true, completion: nil)
    }
}
