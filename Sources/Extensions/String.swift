//
//  String.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation

extension String {
    var nsrange: NSRange {
        return NSRange(location: 0, length: self.count)
    }

    func isNumber() -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "^\\d*$") else { return false }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

        return !matches.isEmpty
    }

    var localLanguageCodeRemoved: String {
        let split = self.split(separator: ":")
        if split.count == 2,
            split[0] == Locale.current.languageCode! {
            return String(split[1])
        }
        return self
    }

    var htmlDecoded: String {
        let decoded: String? = nil
            //try? NSAttributedString(data: Data(utf8), options: [
            //.documentType: NSAttributedString.DocumentType.html,
            //.characterEncoding: String.Encoding.utf8.rawValue
        //], documentAttributes: nil).string

        return decoded ?? self
    }

    func searchBetweenRegexes(from endOfRegexA: String, to endOfRegexB: String) throws -> String? {
        guard endOfRegexB.contains(endOfRegexA) else {
            throw NSError(domain: "RegexB must contain RegexA to find the difference between them", code: Errors.codes.regexSearchStringError.rawValue)
        }

        let startIndex = self.range(of: endOfRegexA, options: .regularExpression)?.upperBound
        let endIndex = self.range(of: endOfRegexB, options: .regularExpression)?.upperBound
        if let start = startIndex, let end = endIndex {
            let result = self[start..<end]
            return String(result)
        }

        return nil
    }

}

extension String: Pickable {
    var rowTitle: String {
        return self
    }
}
