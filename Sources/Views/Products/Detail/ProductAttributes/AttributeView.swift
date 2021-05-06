//
//  AttributeView.swift
//  OpenFoodFacts
//
//  Created by Alexander Scott Beaty on on 17/10/2020.
//  Copyright © 2020 Alexander Scott Beaty. All rights reserved.
//

import UIKit
import Kingfisher
import Cartography

@IBDesignable class AttributeView: UIView {

    @IBOutlet weak var iconWebView: UIWebView!
    @IBOutlet weak var descriptionShort: UITextView!

    var attribute: Attribute?

    func configure(_ attribute: Attribute) {
        self.layer.cornerRadius = 5
        self.attribute = attribute

        iconWebView.delegate = self
        setIconWebView(imageURL: attribute.iconUrl)

        if let label = attribute.name, let description = attribute.descriptionShort ?? attribute.title {
            let text = AttributedStringFormatter.formatAttributedText(label: label, description1: description)
            descriptionShort.attributedText = text
        }
    }

    static func loadFromNib() -> AttributeView {
        let nib = UINib(nibName: "AttributeView", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! AttributeView
        return view
    }

    func setIconWebView(imageURL: String?) {
        guard let iconURL = imageURL else {
            iconWebView.isHidden = true
            iconWebView.removeFromSuperview()
            return
        }

        if let url = URL(string: iconURL) {
            let imageRequest = URLRequest(url: url)
            iconWebView.loadRequest(imageRequest)
        }

        iconWebView.isHidden = false
    }

    private func scaleWebViewForSVGcontent(_ webView: UIWebView) {
        if let contentSize = getSVGdimensions(from: getHTMLfrom(webView: webView)) {
            let webViewSize = webView.frame.size
            print("webviewsize \(webViewSize)")//DEBUG
            print("webview bounds \(webView.bounds.size)")//DEBUG
            webView.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            let scaleFactor = webViewSize.width / contentSize.width

            webView.scrollView.minimumZoomScale = scaleFactor
            webView.scrollView.maximumZoomScale = scaleFactor
            webView.scrollView.zoomScale = scaleFactor

            webView.scalesPageToFit = false
        }
    }

    private func wrapText(around webview: UIWebView) {
//        layoutIfNeeded()
        let exclusionPathFrame = convert(webview.frame, to: descriptionShort)
        let iconImagePath = UIBezierPath(rect: exclusionPathFrame)
        descriptionShort.textContainer.exclusionPaths.append(iconImagePath)
//        layoutSubviews()
    }

    private func getHTMLfrom(webView: UIWebView) -> String? {
        return webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
    }

    public func getSVGdimensions(from html: String?) -> CGSize? {
        var contentSize: CGSize?
        guard let searchString = html else { return nil }
        let regexpA = "width=\""
        let regexpB = "width=\"\\d*"
        let regexpC = "height=\""
        let regexpD = "height=\"\\d*"
        do {
            var width: CGFloat = 0
            var height: CGFloat = 0
            if let widthString = try searchString.searchBetweenRegexes(from: regexpA, to: regexpB) {
                if let widthFloat = Float(widthString) {
                    width = CGFloat(widthFloat)
                }
            }

            if let heightString = try searchString.searchBetweenRegexes(from: regexpC, to: regexpD) {
                if let heightFloat = Float(heightString) {
                    height = CGFloat(heightFloat)
                }
            }

            if width > 0 && height > 0 {
                contentSize = CGSize(width: width, height: height)
                return contentSize
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }

        return nil
    }
}

extension AttributeView: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        wrapText(around: webView)
        scaleWebViewForSVGcontent(webView)
    }
}

protocol formatAttributedString {
    static var boldWordsPattern: String {get}

    static func formatAttributedText(label: String, description1: String) -> NSMutableAttributedString?
    static func makeWordsBold(for originalText: NSAttributedString) -> NSAttributedString
}

class AttributedStringFormatter: formatAttributedString {
    static var boldWordsPattern: String { return "(_\\w+_)" }

    static func formatAttributedText(label: String, description1: String) -> NSMutableAttributedString? {
        // TODO: change description1 parameter back to description and remove below temp var 'description'
        var description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        let headline = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize)
        var bold: [NSAttributedString.Key: Any] = [:]
        if #available(iOS 13.0, *) {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: headline]
        } else {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: headline]
        }

        let body = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize)
        var regular: [NSAttributedString.Key: Any] = [:]
        if #available(iOS 13.0, *) {
            regular = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: body]
        } else {
            regular = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: body]
        }
        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: label + "\n", attributes: bold))

        let descrip = NSAttributedString(string: description, attributes: regular)
        combination.append(descrip)

        return combination
    }

    /// Create an attributed string with word surrounded by '_' (e.g. _Milk_) bold.
    ///
    /// - Parameter originalText: Original text with words to be made bold surrounded by '_'
    /// - Returns: NSAttributedString with highlighted words
    static func makeWordsBold(for originalText: NSAttributedString) -> NSAttributedString {
        let body = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize)
        let headline = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline).pointSize)
        let highlightedText = NSMutableAttributedString(attributedString: originalText)
        var bold: [NSAttributedString.Key: Any] = [:]
        if #available(iOS 13.0, *) {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: headline]
        } else {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: headline]
        }
        var regular: [NSAttributedString.Key: Any] = [:]
        if #available(iOS 13.0, *) {
            regular = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: body]
        } else {
            regular = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: body]
        }
        highlightedText.addAttributes(regular, range: originalText.string.nsrange)

        do {
            let regex = try NSRegularExpression(pattern: boldWordsPattern)
            let matches = regex.matches(in: originalText.string, range: originalText.string.nsrange)

            for match in matches.reversed() {
                highlightedText.setAttributes(bold, range: match.range)

                // Delete underscore characters
                var trailingRange = match.range(at: 1)
                trailingRange.location += trailingRange.length - 1
                trailingRange.length = 1
                var initialRange = match.range(at: 1)
                initialRange.length = 1
                highlightedText.deleteCharacters(in: trailingRange)
                highlightedText.deleteCharacters(in: initialRange)
            }
        } catch let error {
            let userInfo = ["bold_words_pattern": boldWordsPattern, "original_text": originalText.string]
            AnalyticsManager.record(error: error, withAdditionalUserInfo: userInfo)
        }

        return highlightedText
    }
}
