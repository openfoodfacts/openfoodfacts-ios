//
//  LoggedInViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SafariServices

class LoggedInViewController: ChildViewController {
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        if let username = CredentialsController.shared.getUsername() {
            usernameLabel.text = username
        } else {
            dismiss()
        }
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        CredentialsController.shared.clearCredentials()
        dismiss()
    }

    @IBAction func didTapYourContributionsButton(_ sender: UIButton) {
        if let username = CredentialsController.shared.getUsername(), let url = URL(string: URLs.YourContributions + username) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            present(vc, animated: true)
        }
    }
}
