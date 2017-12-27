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
        let vc: UIViewController

        if CredentialsController.shared.getUsername() != nil {
            vc = createLoggedIn()
        } else {
            vc = createLogIn()
        }

        transition(to: vc)
    }

    private func createLoggedIn() -> UIViewController {
        let vc = LoggedInViewController.loadFromStoryboard(named: .user) as LoggedInViewController
        vc.dataManager = dataManager
        vc.delegate = self

        childNavigationController.pushViewController(vc, animated: true)

        return childNavigationController
    }

    private func createLogIn() -> LoginViewController {
        let vc = LoginViewController.loadFromStoryboard(named: .user) as LoginViewController
        vc.dataManager = dataManager
        vc.delegate = self
        return vc
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
        let vc = PendingUploadTableViewController.loadFromStoryboard(named: .user) as PendingUploadTableViewController
        vc.dataManager = dataManager
        childNavigationController.pushViewController(vc, animated: true)
    }
}
