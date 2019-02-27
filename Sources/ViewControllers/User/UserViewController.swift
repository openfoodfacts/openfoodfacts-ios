//
//  UserViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

// MARK: - UserViewController
class UserViewController: UIViewController, DataManagerClient {
    var dataManager: DataManagerProtocol!
    var childNavigationController: UINavigationController!

    override func viewDidLoad() {
        if childNavigationController == nil {
            childNavigationController = UINavigationController()
        }

        loadChildVC()
    }

    private func loadChildVC() {
        let childNavigationVC: UIViewController

        if CredentialsController.shared.getUsername() != nil {
            createLoggedIn()

            if !dataManager.getItemsPendingUpload().isEmpty {
                showProductsPendingUpload()
            }

            childNavigationVC = childNavigationController

        } else {
            childNavigationVC = createLogIn()
        }

        transition(to: childNavigationVC)
    }

    private func createLoggedIn() {
        let loggedInVC = LoggedInViewController.loadFromStoryboard(named: .user) as LoggedInViewController
        loggedInVC.dataManager = dataManager
        loggedInVC.delegate = self

        childNavigationController.pushViewController(loggedInVC, animated: true)
    }

    private func createLogIn() -> LoginViewController {
        let loginVC = LoginViewController.loadFromStoryboard(named: .user) as LoginViewController
        loginVC.dataManager = dataManager
        loginVC.delegate = self
        return loginVC
    }
}

protocol UserViewControllerDelegate: class {
    func dismiss()
    func showProductsPendingUpload()
}

extension UserViewController: UserViewControllerDelegate {
    func dismiss() {
        loadChildVC()
    }

    func showProductsPendingUpload() {
        let pendingUploadTableVC = PendingUploadTableViewController.loadFromStoryboard(named: .user) as PendingUploadTableViewController
        pendingUploadTableVC.dataManager = dataManager
        self.navigationController?.pushViewController(pendingUploadTableVC, animated: true)
    }
}
