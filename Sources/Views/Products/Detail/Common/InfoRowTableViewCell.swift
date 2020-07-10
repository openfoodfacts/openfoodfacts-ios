//
//  ProductIngredientsTableViewCell.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 02/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit

class InfoRowTableViewCell: ProductDetailBaseCell {

    @IBOutlet weak var textView: UITextView!
    //private static let textSize: CGFloat = 17
    private let boldWordsPattern = "(_\\w+_)"

    override func configure(with formRow: FormRow, in viewController: FormTableViewController) {
        let headline = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline), size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.headline).pointSize)

        guard let rowLabel = formRow.label else { return }
        guard let value = formRow.getValueAsAttributedString() else { return }
        var bold: [NSAttributedString.Key: Any] = [:]
        if #available(iOS 13.0, *) {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: headline]
        } else {
            bold = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: headline]
        }

        let combination = NSMutableAttributedString()
        combination.append(NSAttributedString(string: rowLabel + ": ", attributes: bold))
        combination.append(makeWordsBold(for: value))

        self.textView.attributedText = combination

        self.textView.delegate = viewController
    }

    /// Create an attributed string with word surrounded by '_' (e.g. _Milk_) bold.
    ///
    /// - Parameter originalText: Original text with words to be made bold surrounded by '_'
    /// - Returns: NSAttributedString with highlighted words
    private func makeWordsBold(for originalText: NSAttributedString) -> NSAttributedString {
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
