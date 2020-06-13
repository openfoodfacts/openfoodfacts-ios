//
//  EnvironmentImpactTableFormTableViewController.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 27/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class EnvironmentImpactTableFormTableViewController: UIViewController {

    fileprivate var webView: WKWebView? = nil {
        didSet {
            if #available(iOS 13.0, *) {
                webView?.backgroundColor = UIColor.systemBackground
            } else {
                webView?.backgroundColor = UIColor.white
            }
            webView?.translatesAutoresizingMaskIntoConstraints = false
            webView?.navigationDelegate = self
            if let validWebView = self.webView {
                self.view.addSubview(validWebView)
                self.view.addConstraints([
                    NSLayoutConstraint(item: validWebView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 8),
                    NSLayoutConstraint(item: validWebView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -8),
                    NSLayoutConstraint(item: validWebView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 8),
                    NSLayoutConstraint(item: validWebView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -8)
                    ])
            }
        }
    }
    var product: Product? {
        didSet {
            if isViewLoaded {
                reloadHTML()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadHTML()
    }

    func reloadHTML() {
        guard let html = product?.environmentInfoCard else {
            webView?.isHidden = true
            return
        }
        webView?.loadHTMLString(html, baseURL: nil)
    }

}

extension EnvironmentImpactTableFormTableViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "product-detail.page-title.environment-impact".localized)
    }

}

extension EnvironmentImpactTableFormTableViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system-body\"", completionHandler: nil)
    }

}
