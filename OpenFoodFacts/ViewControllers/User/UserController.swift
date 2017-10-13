//
//  UserController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 13/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class UserController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    var contentInsetsBeforeKeyboard = UIEdgeInsets.zero

    override func viewDidLoad() {
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
    }

    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false
        IQKeyboardManager.sharedManager().enable = false
    }

    @IBAction func didTapLoginButton(_ sender: UIButton) {
    }
}
