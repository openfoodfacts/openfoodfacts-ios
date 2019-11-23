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
            let font = UIFont.preferredFont(forTextStyle: .body)
            if #available(iOS 13.0, *) {
                webView.loadHTMLString(html.htmlFormattedString(font: font, color: .label), baseURL: nil)
            } else {
                webView.loadHTMLString(html.htmlFormattedString(font: font, color: .black), baseURL: nil)
            }
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
        //webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system-body\"")

        // to force redraw of cell height
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}

extension String {

func htmlFormattedString( font: UIFont, color: UIColor) -> String {

    func colorHexString(color: UIColor) -> String {
        let colorComponents = color.cgColor.components ?? []
        if color.cgColor.numberOfComponents == 4 {
            let red = colorComponents[0] * 255
            let green = colorComponents[1] * 255
            let blue = colorComponents[2] * 255

            return NSString(format: "%02X%02X%02X", Int(red), Int(green), Int(blue)) as String
        } else if color.cgColor.numberOfComponents == 2 {
            let white = colorComponents[0] * 255

            return NSString(format: "%02X%02X%02X", Int(white), Int(white), Int(white)) as String
        } else {
            return "htmlFormattedString:Color format not supported"
        }
    }
    // The table contains returns /n in strange places. Just to be sure they are removed.
    return String(format: "<html><head><style>table {font-family: -apple-system; font-size: %@; color:#%@;}</style></head><body>%@</body></html>", String(describing: font.pointSize), colorHexString(color: color), self.replacingOccurrences(of: "\n", with: ""))
    }

}
