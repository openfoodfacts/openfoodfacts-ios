//
//  CreditsViewController.swift
//  OpenFoodFacts
//
//  Created by Егор on 2/16/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CreditsViewController: UIViewController {

    private let creditsHTMLFile = (name: "Credits", type: "html")

    private var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        webView = UIWebView(frame: .zero)
        webView.backgroundColor = .white
        webView.clipsToBounds = true
        webView.delegate = self
        webView.scrollView.indicatorStyle = .white
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        loadHTMLForWebView()
    }

    private func loadHTMLForWebView() {
        guard let htmlCreditsFilePath = Bundle.main.path(forResource: creditsHTMLFile.name, ofType: creditsHTMLFile.type),
            let htmlContent = try? String(contentsOfFile: htmlCreditsFilePath) else {
                return
        }
        webView.loadHTMLString(htmlContent, baseURL: Bundle.main.bundleURL)
    }

}

extension CreditsViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked, let requestURL = request.url {
            UIApplication.shared.openURL(requestURL)
            return false
        }

        return true
    }

}
