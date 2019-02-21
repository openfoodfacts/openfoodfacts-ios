//
//  LoggedInViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    weak var delegate: UserViewControllerDelegate?

    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        if let username = CredentialsController.shared.getUsername() {
            usernameLabel.text = username
        } else {
            delegate?.dismiss()
        }
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        //create a logout alertviewcontroller
        let logoutAlert = UIAlertController(title: "Notice", message: "Are you sure you want to log out ?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            CredentialsController.shared.clearCredentials()
            self.delegate?.dismiss()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        logoutAlert.addAction(noAction)
        logoutAlert.addAction(yesAction)
        self.present(logoutAlert, animated: true, completion: nil)
    }

    @IBAction func didTapYourContributionsButton(_ sender: UIButton) {
        if let username = CredentialsController.shared.getUsername(), let url = URL(string: URLs.YourContributions + username) {
            openUrlInApp(url)
        }
    }

    @IBAction func didTapProductsPendingUploadButton(_ sender: UIButton) {
        delegate?.showProductsPendingUpload()
    }
}
