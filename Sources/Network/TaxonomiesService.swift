//
//  TaxonomiesService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 03/02/2019.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum TaxonomiesRoute: String {
    case getAllergens = "taxonomies/allergens.json"
    case getAdditives = "taxonomies/additives.json"
    case getCategories = "taxonomies/categories.json"
    case getCountries = "taxonomies/countries.json"
    case getNutriments = "taxonomies/nutrients.json"
    case getIngredientsAnalysis = "taxonomies/ingredients_analysis.json"
    case getIngredientsAnalysisConfig = "/files/app/ingredients-analysis.json"
    case getVitamins = "taxonomies/vitamins.json"
    case getMinerals = "taxonomies/minerals.json"
    case getNucleotides = "taxonomies/nucleotides.json"
    case getInvalidBarcodes = "invalid-barcodes.json"
    case getLabels = "taxonomies/labels.json"
}

enum FilesRouter: URLRequestConvertible {
    case getIngredientsAnalysisConfig, getTagline

    var path: String {
        switch self {
        case .getIngredientsAnalysisConfig:
            return "app/ingredients-analysis.json"
        case .getTagline:
            return "app/tagline/tagline-off-ios.json"
        }
    }

    // MARK: URRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let urlStr = Endpoint.get + "/files/" + self.path

        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "Taxonomies file url could not be constructed", code: Errors.codes.generic.rawValue, userInfo: ["path": self.path])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

        return urlRequest
    }
}

protocol TaxonomiesApi {
    /// get the tagline, from the local cache then from the api. callback can be callled 0, once or twice.
    func getTagline(_ callback: @escaping (_: Tagline?) -> Void)
    /// if the time delta since last refresh is passed, we download all taxonomies from the server and store them locally for future use
    func refreshTaxonomiesFromServerIfNeeded()
}

class TaxonomiesService: TaxonomiesApi {
    var persistenceManager: PersistenceManagerProtocol!
    private let taxonomiesParser: TaxonomiesParserProtocol

    init(taxonomiesParser: TaxonomiesParserProtocol) {
        self.taxonomiesParser = taxonomiesParser
    }

    fileprivate func refreshCategories(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getCategories, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let categories = self.taxonomiesParser.parseCategories(data: json)
                            self.persistenceManager.save(categories: categories)
                            callback(true)
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                        callback(false)
                    }
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshCountries(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getCountries, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let countries = self.taxonomiesParser.parseCountries(data: json)
                            self.persistenceManager.save(countries: countries)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }

                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshAllergens(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getAllergens, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let allergens = self.taxonomiesParser.parseAllergens(data: json)
                            self.persistenceManager.save(allergens: allergens)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshVitamins(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getVitamins, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let vitamins = self.taxonomiesParser.parseVitamins(data: json)
                            self.persistenceManager.save(vitamins: vitamins)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshMinerals(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getMinerals, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let minerals = self.taxonomiesParser.parseMinerals(data: json)
                            self.persistenceManager.save(minerals: minerals)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshNucleotides(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getNucleotides, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let nucleotides = json.compactMap({ (nucleotideCode: String, value: Any) -> Nucleotide? in
                                guard let value = value as? [String: Any], let name = value["name"] as? [String: String] else {
                                    return nil
                                }
                                let names = name.map({ (languageCode: String, value: String) -> Tag in
                                    return Tag(languageCode: languageCode, value: value)
                                })
                                return Nucleotide(code: nucleotideCode, names: names)
                            })
                            self.persistenceManager.save(nucleotides: nucleotides)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshNutriments(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getNutriments, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let nutriments = self.taxonomiesParser.parseNutriments(data: json)
                            self.persistenceManager.save(nutriments: nutriments)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }

                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshAdditives(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getAdditives, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let additives = self.taxonomiesParser.parseAdditives(data: json)
                            self.persistenceManager.save(additives: additives)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshIngredientsAnalysis(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getIngredientsAnalysis, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let ingredientsAnalysis = self.taxonomiesParser.parseIngredientsAnalysis(data: json)
                            self.persistenceManager.save(ingredientsAnalysis: ingredientsAnalysis)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                    callback(success)
            }
        } catch {
            callback(false)
        }
    }

    fileprivate func refreshIngredientsAnalysisConfig(_ callback: @escaping (_: Bool) -> Void) {
        Alamofire.request(FilesRouter.getIngredientsAnalysisConfig)
            .responseJSON { (response) in
                var success = false
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any] {
                        let ingredientsAnalysisConfig = self.taxonomiesParser.parseIngredientsAnalysisConfig(data: json)
                        self.persistenceManager.save(ingredientsAnalysisConfig: ingredientsAnalysisConfig)
                        success = true
                    }
                case .failure(let error):
                    AnalyticsManager.record(error: error)
                }

                callback(success)
        }
    }

    func getTagline(_ callback: @escaping (_: Tagline?) -> Void) {
        if let cachedTagline = self.persistenceManager.tagLine() {
            callback(cachedTagline)
        }

        Alamofire.request(FilesRouter.getTagline)
            .responseJSON { (response) in
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [[String: Any]] {
                        let userLanguage = NSLocale.autoupdatingCurrent.identifier
                        let item = json.first { $0["language"] as? String == userLanguage} ??
                            json.first { ($0["language"] as? String)?.hasPrefix(userLanguage.split(separator: "_")[0] + "_") == true } ??
                            json.first { $0["language"] as? String == "fallback" }

                        if let data = item?["data"] as? [String: String] {
                            if let url = data["url"], let message = data["message"] {
                                let tagLine = Tagline(url: url, message: message)
                                self.persistenceManager.save(tagLine: tagLine)
                                callback(tagLine)
                                return
                            }
                        }
                    }
                case .failure(let error):
                    AnalyticsManager.record(error: error)
                }

            callback(nil)
        }
    }

    fileprivate func refreshInvalidBarcodes(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getInvalidBarcodes, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    var success = false
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String] {
                            let values = json.map { InvalidBarcode(barcode: $0) }
                            self.persistenceManager.clearInvalidBarcodes()
                            self.persistenceManager.save(invalidBarcodes: values)
                            success = true
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                    }
                callback(success)
            }
        } catch {
             callback(false)
        }
    }

    fileprivate func refreshLabels(_ callback: @escaping (_: Bool) -> Void) {
        do {
            let request = try TaxonomiesRequest(route: .getLabels, requestType: .get).asURLRequest()
            Alamofire.request(request)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let responseBody):
                        if let json = responseBody as? [String: Any] {
                            let labels = self.taxonomiesParser.parseLabels(data: json)
                            self.persistenceManager.save(labels: labels)
                            callback(true)
                        }
                    case .failure(let error):
                        AnalyticsManager.record(error: error)
                        callback(false)
                    }
            }
        } catch {
            callback(false)
        }
    }
    // swiftlint:disable identifier_name

    /// increment last number each time you want to force a refresh. Useful if you add a new refresh method or a new field
    static fileprivate let USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD = "USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD__15"
    static fileprivate let LAST_DOWNLOAD_DELAY: Double = 60 * 60 * 24 * 31 // 1 month

    // swiftlint:enable identifier_name

    func refreshTaxonomiesFromServerIfNeeded() {
        let lastDownload = UserDefaults.standard.double(forKey: TaxonomiesService.USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD)

        let shouldDownload = lastDownload == 0 ||
            (Date().timeIntervalSince1970 - TaxonomiesService.LAST_DOWNLOAD_DELAY) > lastDownload ||
        // check if there are taxonomies that are empty,
        // i.e. not yet downloaded
            persistenceManager.categoriesIsEmpty ||
            persistenceManager.countriesIsEmpty ||
            persistenceManager.allergensIsEmpty ||
            persistenceManager.mineralsIsEmpty ||
            persistenceManager.vitaminsIsEmpty ||
            persistenceManager.nucleotidesIsEmpty ||
            // persistenceManager.otherNutritionalSubstancesIsEmpty ||
            persistenceManager.ingredientsAnalysisIsEmpty ||
            persistenceManager.ingredientsAnalysisConfigIsEmpty ||
            persistenceManager.labelsIsEmpty
        if shouldDownload {
            downloadTaxonomies()
        } else {
            log.debug("TaxonomiesService: Do not download taxonomies, we already have them !")
        }
    }

    private func downloadTaxonomies() {
        DispatchQueue.global(qos: .utility).async {
            let group = DispatchGroup()
            var allSuccess = true

            group.enter()
            self.refreshCategories({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshCountries({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshAllergens({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshVitamins({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshMinerals({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshNucleotides({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshNutriments({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshAdditives({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshIngredientsAnalysis({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshIngredientsAnalysisConfig({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.enter()
            self.refreshInvalidBarcodes { (success) in
                allSuccess = allSuccess && success
                group.leave()
            }

            group.enter()
            self.refreshLabels({ (success) in
                allSuccess = allSuccess && success
                group.leave()
            })

            group.wait()

            if allSuccess {
                log.debug("Taxonomies downloaded !")
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: TaxonomiesService.USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD)
            } else {
                log.debug("It seems that there was some problem downloading one kind of taxonomy ? !")
            }
        }
    }
}
