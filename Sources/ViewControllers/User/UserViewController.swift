//
//  UserViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NotificationBanner
import IBLocalizable

class UserViewController: UIViewController, DataManagerClient {

// MARK: Generic interface elements

    @IBOutlet weak var loginOrOutButton: UIButton! {
        didSet {
            setButtonTitle()
        }
    }

    @IBOutlet weak var explanationLabel: UILabel! {
        didSet {
            explanationLabel.text = isLoggedIn ? "user.logged-in-explanation.label".localized : "user.why-log-in.text".localized
        }
    }

    @IBOutlet weak var logInStackView: UIStackView!
    @IBOutlet weak var userNamePasswordStackView: UIStackView!
    @IBOutlet weak var loggedInStackView: UIStackView!
    @IBOutlet weak var loggedInUserNameLabel: UILabel!

// MARK: Public functions

    var dataManager: DataManagerProtocol!

    private var isLoggedIn: Bool {
        CredentialsController.shared.getUsername() != nil
    }

    private func setupInterface() {
        if let username = CredentialsController.shared.getUsername() {
            hideLogInViews(true)
            title = username
            loggedInUserNameLabel.text = String(format: "user.logged-in.label".localized, username)
            loginOrOutButton.isEnabled = true
        } else {
            hideLogInViews(false)
            title = "user.not-logged-in".localized
            loginOrOutButton.isEnabled = loginDataIsAvalaible
        }
        setButtonTitle()
    }

    private func hideLogInViews(_ hide: Bool) {
        // views shown when NOT logged in
        logInStackView.isHidden = hide
        userNamePasswordStackView.isHidden = hide
        // views shown when LOGGED in
        loggedInStackView.isHidden = !hide
        loggedInUserNameLabel.isHidden = !hide
    }

    private func setButtonTitle() {
        loginOrOutButton?.setTitle(isLoggedIn ? "user.log-out".localized : "user.log-in".localized, for: .normal)
    }

    @IBAction func didTapSignOut(_ sender: UIButton) {
        if isLoggedIn {
            setupLogout()
        } else {
            setupLogin()
        }
    }

// MARK: Log in variables / and unctions

    @IBOutlet weak var usernameField: UITextField! {
        didSet {
            usernameField?.delegate = self
        }
    }

    @IBOutlet weak var passwordField: UITextField! {
           didSet {
               passwordField?.delegate = self
           }
       }

    private var loginDataIsAvalaible: Bool {
        guard let username = usernameField?.text else { return false }
        guard let password = passwordField?.text else { return false }
        return !username.isEmpty && !password.isEmpty
    }

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

    @IBOutlet weak var createAnAccountButton: UIButton! {
        didSet {
            createAnAccountButton?.setTitle("user.create-account.button".localized, for: .normal)
            createAnAccountButton?.titleLabel?.lineBreakMode = .byWordWrapping
        }
    }

    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton?.setTitle("user.forgot-password".localized, for: .normal)
            forgotPasswordButton?.titleLabel?.lineBreakMode = .byWordWrapping
        }
    }
    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        if let url = URL(string: URLs.ForgotPassword) {
            openUrlInApp(url)
        }
    }

    @IBAction func didTapCreateAccountButton(_ sender: UIButton) {
        if let url = URL(string: URLs.CreateAccount) {
            openUrlInApp(url)
        }
    }

    private func setupLogin() {
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
        loginOrOutButton.setTitle("user.logging-in".localized, for: .normal)
        // loginOrOutButton.isEnabled = false
        dataManager.logIn(username: username, password: password, onSuccess: {
            self.setupInterface()
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

// MARK: Log out variables and functions

    private func setupLogout() {
        //create a logout alertviewcontroller
        let logoutAlert = UIAlertController(title: "user.alert.logout-confirmation.title".localized, message: "user.alert.logout-confirmation.subtitle".localized, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "generic.ok".localized, style: .default) { (_) in
            CredentialsController.shared.clearCredentials()
            self.setupInterface()
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

// MARK: Pending uploads part

    private struct SegueIdentifier {
        static let PendingUploadsVC = "Pending Uploads VC Segue Identifier"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case SegueIdentifier.PendingUploadsVC:
            if let destinationVC = segue.destination as? PendingUploadTableViewController {
                destinationVC.dataManager = dataManager
            }
        default: break
        }
    }

    @IBOutlet weak var productsPendingUploadButton: UIButton! {
        didSet {
            if let items = dataManager?.getItemsPendingUpload() {
                if items.isEmpty {
                productsPendingUploadButton.setTitle("user.products-pending-upload-none.button".localized, for: .normal)
                } else {
                productsPendingUploadButton.setTitle("user.products-pending-upload.button".localized, for: .normal)
                }
            }
        }
    }

    @IBAction func didTapProductsPendingUploadButton(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.PendingUploadsVC, sender: self)
    }

// MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false
        IQKeyboardManager.sharedManager().enable = false
        super.viewWillDisappear(animated)
    }

}

// MARK: Extensions

extension UserViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != nil,
            !textField.text!.isEmpty {
            loginOrOutButton.isEnabled = loginDataIsAvalaible
        }
        return true
    }
}
