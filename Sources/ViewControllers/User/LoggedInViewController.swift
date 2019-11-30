//
//  LoggedInViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//
/*
import IBLocalizable
import UIKit

class LoggedInViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    weak var delegate: UserViewControllerDelegate?

    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        if let username = CredentialsController.shared.getUsername() {
            usernameLabel.text = String(format: "user.logged-in.label".localized, username)
            // "%@, you are logged in"
        } else {
            delegate?.dismiss()
        }
    }

    @IBOutlet weak var explanationLabel: UILabel! {
        didSet {
            explanationLabel.text = "user.logged-in-explanation.label".localized
            // All the products you add and the product photos you upload will be credited to your account"
        }
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        //create a logout alertviewcontroller
        let logoutAlert = UIAlertController(title: "user.alert.logout-confirmation.title".localized, message: "user.alert.logout-confirmation.subtitle".localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "generic.ok".localized, style: .default) { (_) in
            CredentialsController.shared.clearCredentials()
            self.delegate?.dismiss()
        }
        let noAction = UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil)

        logoutAlert.addAction(noAction)
        logoutAlert.addAction(yesAction)
        self.present(logoutAlert, animated: true, completion: nil)
    }

    @IBAction func didTapYourContributionsButton(_ sender: UIButton) {
        if let username = CredentialsController.shared.getUsername() {
            let parts = username.split(separator: "@")
            if !parts.isEmpty, let url = URL(string: URLs.YourContributions + parts[0]) {
                openUrlInApp(url)
            }
        }
    }

    @IBAction func didTapProductsPendingUploadButton(_ sender: UIButton) {
        delegate?.showProductsPendingUpload()
    }
}
*/
