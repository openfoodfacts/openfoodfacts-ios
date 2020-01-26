//
//  UIViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import SafariServices
import NotificationBanner

extension UIViewController {

    static func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: .main)
    }

    static func loadFromStoryboard<T: UIViewController>(named storyboardName: StoryboardNames? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName?.rawValue ?? String(describing: self), bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        // swiftlint:disable:previous force_cast
    }

    static func loadFromMainStoryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        // swiftlint:disable:previous force_cast
    }

    func openUrlInApp(_ url: URL, showAlert: Bool? = nil) {
        let sfSafariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        present(sfSafariVC, animated: true)

        if showAlert == true {
            NotificationBanner(title: "product-detail.edit-alert.title".localized,
                               subtitle: "product-detail.edit-alert.subtitle".localized,
                               style: .warning).show()
        }
    }

    func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3

        let current = children.last
        addChild(child)

        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds

        if let existing = current {
            existing.willMove(toParent: nil)

            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParent()
                child.didMove(toParent: self)
                completion?(done)
            })

        } else {
            view.addSubview(newView)

            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParent: self)
                completion?(done)
            })
        }
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }

        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        if self.presentedViewController == nil {
            return self
        }
        return self.presentedViewController?.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
