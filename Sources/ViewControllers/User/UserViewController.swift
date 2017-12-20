//
//  UserViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

// MARK: - UserViewController
class UserViewController: UIViewController, ProductApiClient {
    var productApi: ProductApi!

    override func viewDidLoad() {
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

    private func createLoggedIn() -> LoggedInViewController {
        let vc = LoggedInViewController.loadFromStoryboard(named: StoryboardNames.user) as LoggedInViewController
        vc.productApi = productApi
        vc.delegate = self
        return vc
    }

    private func createLogIn() -> LoginViewController {
        let vc = LoginViewController.loadFromStoryboard(named: StoryboardNames.user) as LoginViewController
        vc.productApi = productApi
        vc.delegate = self
        return vc
    }
}

protocol UserViewControllerDelegate: class {
    func dismiss()
}

extension UserViewController: UserViewControllerDelegate {
    func dismiss() {
        loadChildVC()
    }
}
