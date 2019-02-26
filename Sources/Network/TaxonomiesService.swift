//
//  TaxonomiesService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 03/02/2019.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Crashlytics

enum TaxonomiesRouter: URLRequestConvertible {
    case getAllergens, getAdditives, getCategories, getNutriments

    var path: String {
        switch self {
        case .getAllergens: return "/allergens.json"
        case .getAdditives: return "/additives.json"
        case .getCategories: return "/categories.json"
        case .getNutriments: return "/nutrients.json"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let urlStr = Endpoint.get + "/data/taxonomies/" + self.path
        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "Taxonomies url could not be constructed", code: Errors.codes.generic.rawValue, userInfo: ["path": self.path])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

        return urlRequest
    }
}

protocol TaxonomiesApi {
    /// if the time delta since last refresh is passed, we download all taxonomies from the server and store them locally for future use
    func refreshTaxonomiesFromServerIfNeeded()
}

class TaxonomiesService: TaxonomiesApi {
    var persistenceManager: PersistenceManagerProtocol!

    fileprivate func refreshCategories(_ callback: @escaping (_: Bool) -> Void) {
        Alamofire.request(TaxonomiesRouter.getCategories)
            .responseJSON { (response) in
                var success = false
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any] {
                        let categories = json.compactMap({ (categoryCode: String, value: Any) -> Category? in
                            guard let value = value as? [String: Any], let name = value["name"] as? [String: String] else {
                                return nil
                            }
                            let names = name.map({ (languageCode: String, value: String) -> Tag in
                                return Tag(languageCode: languageCode, value: value)
                            })
                            return Category(code: categoryCode,
                                            parents: value["parents"] as? [String] ?? [String](),
                                            children: value["children"] as? [String] ?? [String](),
                                            names: names)
                        })
                        self.persistenceManager.save(categories: categories)
                        success = true
                    }
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                }

                callback(success)
        }
    }

    fileprivate func refreshAllergens(_ callback: @escaping (_: Bool) -> Void) {
        Alamofire.request(TaxonomiesRouter.getAllergens)
            .responseJSON { (response) in
                var success = false
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any] {
                        let allergens = json.compactMap({ (allergenCode: String, value: Any) -> Allergen? in
                            guard let value = value as? [String: Any], let name = value["name"] as? [String: String] else {
                                return nil
                            }
                            let names = name.map({ (languageCode: String, value: String) -> Tag in
                                return Tag(languageCode: languageCode, value: value)
                            })
                            return Allergen(code: allergenCode, names: names)
                        })
                        self.persistenceManager.save(allergens: allergens)
                        success = true
                    }
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                }

                callback(success)
        }
    }

    fileprivate func refreshNutriments(_ callback: @escaping (_: Bool) -> Void) {
        Alamofire.request(TaxonomiesRouter.getNutriments)
            .responseJSON { (response) in
                var success = false
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any] {
                        let nutriments = json.compactMap({ (nutrimentCode: String, value: Any) -> Nutriment? in
                            guard let name = value as? [String: Any] else {
                                return nil
                            }
                            let names = name.compactMap({ (languageCode: String, value: Any) -> Tag? in
                                if let value = value as? String {
                                    return Tag(languageCode: languageCode, value: value)
                                }
                                return nil
                            })
                            return Nutriment(code: nutrimentCode, names: names)
                        })
                        self.persistenceManager.save(nutriments: nutriments)
                        success = true
                    }
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                }

                callback(success)
        }
    }

    fileprivate func refreshAdditives(_ callback: @escaping (_: Bool) -> Void) {
        Alamofire.request(TaxonomiesRouter.getAdditives)
            .responseJSON { (response) in
                var success = false
                switch response.result {
                case .success(let responseBody):
                    if let json = responseBody as? [String: Any] {
                        let additives = json.compactMap({ (additiveCode: String, value: Any) -> Additive? in
                            guard let value = value as? [String: Any], let name = value["name"] as? [String: String] else {
                                return nil
                            }
                            let names = name.map({ (languageCode: String, value: String) -> Tag in
                                return Tag(languageCode: languageCode, value: value)
                            })
                            return Additive(code: additiveCode, names: names)
                        })
                        self.persistenceManager.save(additives: additives)
                        success = true
                    }
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                }

                callback(success)
        }
    }

    // swiftlint:disable identifier_name

    /// increment last number each time you want to force a refresh. Useful if you add a new refresh method or a new field
    static fileprivate let USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD = "USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD__10"
    static fileprivate let LAST_DOWNLOAD_DELAY: Double = 60 * 60 * 24 * 31 // 1 month

    // swiftlint:enable identifier_name

    func refreshTaxonomiesFromServerIfNeeded() {
        let lastDownload = UserDefaults.standard.double(forKey: TaxonomiesService.USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD)

        let shouldDownload = lastDownload == 0 || (Date().timeIntervalSince1970 - TaxonomiesService.LAST_DOWNLOAD_DELAY) > lastDownload

        if shouldDownload {
            DispatchQueue.global(qos: .utility).async {
                let group = DispatchGroup()

                var allSuccess = true

                group.enter()
                self.refreshCategories({ (success) in
                    allSuccess = allSuccess && success
                    group.leave()
                })

                group.enter()
                self.refreshAllergens({ (success) in
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

                group.wait()

                if allSuccess {
                    log.debug("Taxonomies downloaded !")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: TaxonomiesService.USER_DEFAULT_LAST_TAXONOMIES_DOWNLOAD)
                } else {
                    log.debug("It seems that there was some problem downloading one kind of taxonomy ? !")
                }
            }
        } else {
            log.debug("Do not download taxonomies, we already have them !")
        }
    }
}
