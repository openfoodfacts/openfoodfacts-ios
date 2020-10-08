import Foundation

/**
 The `TaxonomiesParser` class Parser for taxonomies data
 */
struct TaxonomiesParser: TaxonomiesParserProtocol {
    func parseCategories(data: [String: Any]) -> [Category] {
        let categories = data.compactMap({ (categoryCode: String, value: Any) -> Category? in
            let tags = parseTags(value: value)
            let parents = parseParents(value: value)
            let children = parseChildren(value: value)
            return Category(code: categoryCode,
                            parents: parents,
                            children: children,
                            names: tags)
        })
        return categories
    }

    func parseCountries(data: [String: Any]) -> [Country] {
        let countries = data.compactMap({ (countryCode: String, value: Any) -> Country? in
            let tags = parseTags(value: value)
            let parents = parseParents(value: value)
            let children = parseChildren(value: value)
            return Country(code: countryCode,
                            parents: parents,
                            children: children,
                            names: tags)
        })
        return countries
    }

    func parseAllergens(data: [String: Any]) -> [Allergen] {
        let allergens = data.compactMap({ (allergenCode: String, value: Any) -> Allergen? in
            let tags = parseTags(value: value)
            return Allergen(code: allergenCode, names: tags)
        })
        return allergens
    }

    func parseVitamins(data: [String: Any]) -> [Vitamin] {
        let vitamins = data.compactMap({ (vitaminCode: String, value: Any) -> Vitamin? in
             let tags = parseTags(value: value)
            return Vitamin(code: vitaminCode, names: tags)
        })
        return vitamins
    }

    func parseMinerals(data: [String: Any]) -> [Mineral] {
        let minerals = data.compactMap({ (mineralCode: String, value: Any) -> Mineral? in
            let tags = parseTags(value: value)
            return Mineral(code: mineralCode, names: tags)
        })
        return minerals
    }

    func parseNucleotides(data: [String: Any]) -> [Nucleotide] {
        let nucleotides = data.compactMap({ (nucleotideCode: String, value: Any) -> Nucleotide? in
            let tags = parseTags(value: value)
            return Nucleotide(code: nucleotideCode, names: tags)
        })
        return nucleotides
    }

    func parseNutriments(data: [String: Any]) -> [Nutriment] {
        let nutriments = data.compactMap({ (nutrimentCode: String, value: Any) -> Nutriment? in
            let tags = parseTags(value: value)
            return Nutriment(code: nutrimentCode, names: tags)
        })
        return nutriments
    }

    func parseAdditives(data: [String: Any]) -> [Additive] {
        let additives = data.compactMap({ (additiveCode: String, value: Any) -> Additive? in
            let tags = parseTags(value: value)
            return Additive(code: additiveCode, names: tags)
        })
        return additives
    }

    func parseIngredientsAnalysis(data: [String: Any]) -> [IngredientsAnalysis] {
        let ingredientsAnalysis = data.compactMap { (ingredientAnalysisCode: String, value: Any) -> IngredientsAnalysis? in
            let tags = parseTags(value: value)
            let showIngredientsTag = parseShowIngredientsTag(value: value)

            return IngredientsAnalysis(code: ingredientAnalysisCode,
                                       names: tags,
                                       showIngredientsTag: showIngredientsTag)
        }
        return ingredientsAnalysis
    }

    func parseIngredientsAnalysisConfig(data: [String: Any]) -> [IngredientsAnalysisConfig] {
        let ingredientsAnalysisConfig = data.compactMap({ (ingredientAnalysisConfigCode: String, value: Any) -> IngredientsAnalysisConfig? in
            guard let value = value as? [String: String] else {
                return nil
            }
            guard let type = value["type"], let icon = value["icon"], let color = value["color"] else {
                return nil
            }
            return IngredientsAnalysisConfig(code: ingredientAnalysisConfigCode,
                                             type: type,
                                             icon: icon,
                                             color: color)
        })
        return ingredientsAnalysisConfig
    }

    func parseLabels(data: [String: Any]) -> [Label] {
        let labels = data.compactMap({ (labelCode: String, value: Any) -> Label? in
            let tags = parseTags(value: value)
            let parents = parseParents(value: value)
            let children = parseChildren(value: value)
            return Label(code: labelCode,
                            parents: parents,
                            children: children,
                            names: tags)
        })
        return labels
    }

    // MARK: - Private Helper Methods

    private func parseTags(value: Any) -> [Tag] {
        guard let value = value as? [String: Any], let tagName = value["name"] as? [String: String] else {
            return []
        }
        let tags = tagName.map({ (languageCode: String, value: String) -> Tag in
            return Tag(languageCode: languageCode, value: value)
        })
        return tags
    }

    private func parseParents(value: Any) -> [String] {
        guard let value = value as? [String: Any] else {
            return []
        }
        let parents = value["parents"] as? [String] ?? []
        return parents
    }

    private func parseChildren(value: Any) -> [String] {
        guard let value = value as? [String: Any] else {
            return []
        }
        let parents = value["children"] as? [String] ?? []
        return parents
    }

    private func parseShowIngredientsTag(value: Any) -> String? {
        guard let value = value as? [String: Any] else {
            return nil
        }
        let showIngredientsTag = (value["show_ingredients"] as? [String: String])?["en"]
        return showIngredientsTag
    }
}
