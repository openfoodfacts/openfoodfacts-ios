import Foundation

/**
 The `TaxonomiesParserProtocol` A protocol used to describe the behaviours expected from 'TaxonomiesParser'.
 By using a protocol, we can easily use dependency injection when we create an instance of 'TaxonomiesService'. This can make testing 'TaxonomiesService'
 easier as we will be able to create a 'TaxonomiesParser' mock object that will conform to 'TaxonomiesParserProtocol' and will be injected to 'TaxonomiesService'
 instance when we write the unit tests. The mock object of 'TaxonomiesParser' will contain simpler implementation that can make unit tests easier and faster.
*/
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
    func parseLabels(data: [String: Any]) -> [Label]
}
