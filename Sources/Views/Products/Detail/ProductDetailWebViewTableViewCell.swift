//
//  ProductDetailWebViewTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/03/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class ProductDetailWebViewTableViewCell: ProductDetailBaseCell {
    override class var estimatedHeight: CGFloat { return 160 }

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!

    weak var tableView: UITableView?

    override func awakeFromNib() {
        super.awakeFromNib()

        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
    }

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        if let html = formRow.getValueAsString() {
            webView.loadHTMLString(html, baseURL: nil)
            webView.isHidden = false
        } else {
            webView.isHidden = true
        }
        self.tableView = viewController.tableView
    }
}

// MARK: UIWebViewDelegate
extension ProductDetailWebViewTableViewCell: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeightConstraint.constant = webView.scrollView.contentSize.height

        // to force redraw of cell height
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}
