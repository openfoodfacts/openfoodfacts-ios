//
//  UserViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

// MARK: - ChildViewController
protocol ChildDelegate: class {
    func removeChild(_ child: ChildViewController)
}

class ChildViewController: UIViewController, ProductApiClient {
    weak var delegate: ChildDelegate?
    var productApi: ProductApi!

    func dismiss() {
        self.delegate?.removeChild(self)
    }

    func set(_ productApi: ProductApi) {
        self.productApi = productApi
    }
}

// MARK: - UserViewController
class UserViewController: UIViewController {
    var currentChildVC: UIViewController?
    var productApi: ProductApi!

    override func viewDidLoad() {
        showAppropiateChildViewController()
    }

    private func showAppropiateChildViewController() {
        if CredentialsController.shared.getUsername() != nil {
            presentViewController(identifier: String(describing: LoggedInViewController.self))
        } else {
            presentViewController(identifier: String(describing: LoginViewController.self))
        }
    }

    private func presentViewController(identifier: String) {
        log.debug("Presenting \(identifier)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next force_cast
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ChildViewController
        vc.delegate = self
        vc.set(productApi)
        currentChildVC = vc
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}

extension UserViewController: ChildDelegate {
    func removeChild(_ child: ChildViewController) {
        currentChildVC?.willMove(toParentViewController: nil)
        currentChildVC?.view.removeFromSuperview()
        currentChildVC?.removeFromParentViewController()

        showAppropiateChildViewController()
    }
}

extension UserViewController: ProductApiClient {
    func set(_ productApi: ProductApi) {
        self.productApi = productApi
    }
}
