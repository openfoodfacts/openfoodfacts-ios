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

    private var color: UIColor = .black

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        if let html = formRow.getValueAsString() {
            let font = UIFont.preferredFont(forTextStyle: .body)

            if #available(iOS 13.0, *) {
                color = traitCollection.userInterfaceStyle == .dark ? .white : .black
            } else {
                color = .black
            }
            webView.loadHTMLString(html.htmlFormattedString(font: font, color: color), baseURL: nil)
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
//        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system-body\"")

        // to force redraw of cell height
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}

extension String {

func htmlFormattedString(font: UIFont, color: UIColor) -> String {

    // The table contains returns /n in strange places. Just to be sure they are removed.
    var htmlContent = "<html><head><style>"
    // add a table style for nutrition tabel
    // the rest is for carbon impact by Ademe
    htmlContent += "table,h2,h3,p,li,ul {font-family: -apple-system; font-size: %@; color:#%@;}"
    htmlContent += "</style></head>"
    htmlContent += "<body>%@</body>"
    htmlContent += "</html>"
    let fontSize = String(describing: font.pointSize)
    let newHtml = self.replacingOccurrences(of: "\n", with: "")
    return String(format: htmlContent, fontSize, color.hexString, newHtml)
    }

}
