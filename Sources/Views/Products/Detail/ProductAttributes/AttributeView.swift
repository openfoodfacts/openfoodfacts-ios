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

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionShort: UITextView!

    var attribute: Attribute?

    func configure(_ attribute: Attribute) {
        self.layer.cornerRadius = 5
        self.attribute = attribute

        setIconImageView(imageURL: attribute.iconUrl)
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

    func setIconImageView(imageURL: String?) {
        guard let icon = imageURL, let attribute = attribute,
            let url = URL(string: "https://static.openfoodfacts.org/images/icons/\(attribute.id!.contains("organic") ? "vegan-status-unknown" :  "nutrient-level-salt-medium").png")
            // FIXME: DEBUG STAND IN VALUES, should be "icon" from attribute's imageURL
        else {
            iconImageView.isHidden = false
            return
        }
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] _ in
//            if let aspectRatioConstraint = self?.getIconAspectConstraint() {
//                self?.addConstraint(aspectRatioConstraint)
//            }

            // wrap text around the image
            self?.layoutIfNeeded()
            let exclusionPathFrame = self?.convert((self?.iconImageView.frame)!, to: self?.descriptionShort)
            let iconImagePath = UIBezierPath(rect: exclusionPathFrame!)
            self?.descriptionShort.textContainer.exclusionPaths.append(iconImagePath)
            self?.layoutSubviews()
        }
        iconImageView.isHidden = false
    }

    func getIconAspectConstraint() -> NSLayoutConstraint? {
        guard let imageView = iconImageView, let image = imageView.image else { return nil }
        let height = image.size.width
        let width = image.size.height

        let aspectRatio = width / height

        let aspectConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: aspectRatio, constant: 0)

        return aspectConstraint
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
