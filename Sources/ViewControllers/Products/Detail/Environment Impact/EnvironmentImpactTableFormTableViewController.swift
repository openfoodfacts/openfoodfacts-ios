//
//  EnvironmentImpactTableFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 27/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EnvironmentImpactTableFormTableViewController: UIViewController {

    fileprivate let webView: UIWebView = UIWebView()
    var product: Product? {
        didSet {
            if isViewLoaded {
                reloadHTML()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.backgroundColor = UIColor.white
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)

        self.view.addConstraints([
            NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -8)
            ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadHTML()
    }

    func reloadHTML() {
        guard let html = product?.environmentInfoCard else {
            webView.isHidden = true
            return
        }
        webView.loadHTMLString(html, baseURL: nil)
    }

}

extension EnvironmentImpactTableFormTableViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "product-detail.page-title.environment-impact".localized)
    }

}
