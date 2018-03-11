//
//  LoginViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 13/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NotificationBanner

class LoginViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    weak var delegate: UserViewControllerDelegate?

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    var contentInsetsBeforeKeyboard = UIEdgeInsets.zero

    lazy var errorBanner: NotificationBanner = {
        let banner = NotificationBanner(title: "", subtitle: "", style: .danger)
        return banner
    }()
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert.action.ok".localized,
                                      style: .default,
                                      handler: { _ in alert.dismiss(animated: true, completion: nil) }))
        return alert
    }()

    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false
        IQKeyboardManager.sharedManager().enable = false
    }

    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        if let url = URL(string: URLs.ForgotPassword) {
            openUrlInApp(url)
        }
    }

    @IBAction func didTapLoginButton(_ sender: UIButton) {
        if usernameField.isFirstResponder {
            usernameField.resignFirstResponder()
        } else if passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }

        guard let username = usernameField.text, !username.isEmpty else {
            alert.title = "user.alert.username-missing".localized
            self.present(self.alert, animated: true, completion: nil)
            return
        }

        guard let password = passwordField.text, !password.isEmpty else {
            alert.title = "user.alert.password-missing".localized
            self.present(self.alert, animated: true, completion: nil)
            return
        }

        dataManager.logIn(username: username, password: password, onSuccess: {
            self.delegate?.dismiss()
        }, onError: { error in
            let title: String
            let subtitle: String
            if (error as NSError).code == Errors.codes.wrongCredentials.rawValue {
                title = "user.alert.wrong-credentials.title".localized
                subtitle = "user.alert.wrong-credentials.subtitle".localized
            } else {
                title = "user.alert.generic-error.title".localized
                subtitle = "user.alert.generic-error.subtitle".localized
            }
            self.errorBanner.titleLabel?.text = title
            self.errorBanner.subtitleLabel?.text = subtitle
            self.errorBanner.show()
        })
    }

    @IBAction func didTapCreateAccountButton(_ sender: UIButton) {
        if let url = URL(string: URLs.CreateAccount) {
            openUrlInApp(url)
        }
    }
}
