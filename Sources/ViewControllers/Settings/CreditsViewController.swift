//
//  CreditsViewController.swift
//  OpenFoodFacts
//
//  Created by Егор on 2/16/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit

class CreditsViewController: UIViewController {

    private var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        webView = UIWebView(frame: self.view.frame)
        webView.backgroundColor = .white
        webView.clipsToBounds = true
        webView.delegate = self
        webView.scrollView.indicatorStyle = .white
        self.view.addSubview(webView)
        guard let htmlCreditsFilePath = Bundle.main.path(forResource: "Credits", ofType: "html"),
            let htmlContent = try? String(contentsOfFile: htmlCreditsFilePath) else {
                return
        }
        webView.loadHTMLString(htmlContent, baseURL: Bundle.main.bundleURL)
    }

}

extension CreditsViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let requestURL = request.url else {
            return false
        }
        if UIApplication.shared.canOpenURL(requestURL) {
            return !UIApplication.shared.openURL(requestURL)
        }
        return true
    }

}

