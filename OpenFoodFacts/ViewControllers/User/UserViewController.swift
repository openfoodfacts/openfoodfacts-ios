//
//  UserViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 14/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

protocol ChildDelegate: class {
    func removeChild(_ child: ChildViewController)
}

class ChildViewController: UIViewController {
    weak var delegate: ChildDelegate?

    func dismiss() {
        self.delegate?.removeChild(self)
    }
}

class UserViewController: UIViewController {
    var currentChildVC: UIViewController?

    override func viewDidLoad() {
        showAppropiateChildViewController()
    }

    private func showAppropiateChildViewController() {
        let defaults = UserDefaults.standard

        if defaults.string(forKey: UserDefaultsConstants.username) != nil {
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
