//
//  LoggedInViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class LoggedInViewController: ChildViewController {
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "username") {
            usernameLabel.text = username
        } else {
            dismiss()
        }
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        dismiss()
    }
}
