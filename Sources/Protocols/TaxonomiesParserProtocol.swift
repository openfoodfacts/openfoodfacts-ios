import Foundation

protocol TaxonomiesParserProtocol {
    func parseCategories(data: [String: Any]) -> [Category]
    func parseCountries(data: [String: Any]) -> [Country]
    func parseAllergens(data: [String: Any]) -> [Allergen]
    func parseVitamins(data: [String: Any]) -> [Vitamin]
    func parseMinerals(data: [String: Any]) -> [Mineral]
    func parseNucleotides(data: [String: Any]) -> [Nucleotide]
    func parseNutriments(data: [String: Any]) -> [Nutriment]
    func parseAdditives(data: [String: Any]) -> [Additive]
    func parseIngredientsAnalysis(data: [String: Any]) -> [IngredientsAnalysis]
    func parseIngredientsAnalysisConfig(data: [String: Any]) -> [IngredientsAnalysisConfig]
}
