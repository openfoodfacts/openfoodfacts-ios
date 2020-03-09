//
//  ProductDetailWebViewTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 04/03/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import WebKit

class ProductDetailWebViewTableViewCell: ProductDetailBaseCell {
    override class var estimatedHeight: CGFloat { return 160 }

    var webView: WKWebView? = nil {
        didSet {
            webView?.scrollView.bounces = false
            webView?.scrollView.isScrollEnabled = false
            webView?.navigationDelegate = self
        }
    }

    weak var tableView: UITableView? {
        didSet {
            guard tableView != nil else { return }
            self.frame.size.width = tableView!.frame.size.width
            self.webView?.frame.size.width = self.frame.size.width
        }
    }

    private struct Constant {
        static let Margin: CGFloat = 8.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // The webView must be created in code, otherwise it will not work prior to IOS13
        webView = WKWebView(frame: self.frame)
        if webView != nil {
            self.addSubview(webView!)
        }
    }

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        if let html = formRow.getValueAsString() {
            let font = UIFont.preferredFont(forTextStyle: .body)
            if #available(iOS 13.0, *) {
                webView?.loadHTMLString(html.htmlFormattedString(font: font, color: .label), baseURL: nil)
            } else {
                webView?.loadHTMLString(html.htmlFormattedString(font: font, color: .black), baseURL: nil)
            }
            webView?.isHidden = false
        } else {
            webView?.isHidden = true
        }
        self.tableView = viewController.tableView
    }
}

// MARK: WKNavigationDelegate
extension ProductDetailWebViewTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size.height = webView.scrollView.contentSize.height
        self.frame.size.height = webView.frame.size.height + 2 * Constant.Margin
        //webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"-apple-system-body\"")

        // to force redraw of cell height
        //tableView?.beginUpdates()
        //tableView?.endUpdates()
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
    let string = "<html><head><style>table {font-family: -apple-system; font-size: %@; color:#%@;}</style></head><body>%@</body></html>"
    return String(format: string, String(describing: font.pointSize), colorHexString(color: color), self.replacingOccurrences(of: "\n", with: ""))
    }

}
