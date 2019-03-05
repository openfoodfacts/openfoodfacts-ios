//
//  OfflineService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 05/03/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Zip
import UIKit
import Alamofire
import Crashlytics

protocol OfflineProductsApi {
    func refreshOfflineProductsFromServerIfNeeded(force: Bool)
}

enum OfflineRouter: URLRequestConvertible {
    case getAllProductsInfos

    var path: String {
        switch self {
        case .getAllProductsInfos: return "1.json?fields=null"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let urlStr = Endpoint.get + "/" + self.path
        guard let url = URL(string: urlStr) else {
            throw NSError(domain: "Url could not be constructed", code: Errors.codes.generic.rawValue, userInfo: ["path": self.path])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

        return urlRequest
    }
}

class OfflineProductsService: OfflineProductsApi {
    var persistenceManager: PersistenceManagerProtocol!

    // swiftlint:disable identifier_name

    /// increment last number each time you want to force a refresh. Useful if you add a new refresh method or a new field
    static fileprivate let USER_DEFAULT_LAST_OFFLINE_PRODUCTS_DOWNLOAD = "USER_DEFAULT_LAST_OFFLINE_PRODUCTS_DOWNLOAD__13"
    static fileprivate let LAST_DOWNLOAD_DELAY: Double = 60 * 60 * 24 * 31 // 1 month

    // swiftlint:enable identifier_name

    fileprivate static func deleteFile(atURL: URL) {
        let fileManager = FileManager.default

        do {
            try fileManager.removeItem(at: atURL)
        } catch let error {
            log.error("[Offline_products] file not deleted at \(atURL) because of \(error)")
        }
    }

    // swiftlint:disable:next function_body_length
    fileprivate func downloadFile(completion: @escaping (Bool) -> Void) {

        self.persistenceManager.updateOfflineProductStatus(percent: 0, savedProductsCount: 0)

        let url = URL(string: "https://world.openfoodfacts.org/data/offline/en.openfoodfacts.org.products.small.csv.zip")!

        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)

        Alamofire.request(OfflineRouter.getAllProductsInfos)
            .responseJSON { (res: DataResponse<Any>) in
                var totalProductsCount: Int = 800000
                if let json = res.result.value as? Dictionary<String, Any> {
                    totalProductsCount = json["count"] as? Int ?? totalProductsCount
                }

                Alamofire.download(url, to: destination)
                    .downloadProgress(closure: { (progress) in
                        //progress closure
                        log.debug("[Offline_products] download zip progress = \(progress.fractionCompleted)")
                    }).response(completionHandler: { (result: DefaultDownloadResponse) in

                        guard let localFilePath = result.destinationURL else {
                            log.error("[Offline_products] no downloaded zip destination file ?")
                            completion(false)
                            return
                        }

                        DispatchQueue.global(qos: .userInitiated).async {
                            var success = true
                            do {
                                let unzipedFolderPath = try Zip.quickUnzipFile(localFilePath)

                                let contentFileUrls = try FileManager.default.contentsOfDirectory(at: unzipedFolderPath, includingPropertiesForKeys: nil)

                                if let firstFileURL = contentFileUrls.first {
                                    if let streamReader = TypedCSVStreamReader<RealmOfflineProduct>(url: firstFileURL, csvDelimiter: "\t") {
                                        var totalCount = 0

                                        streamReader.batchStreamCSV(batchSize: 10000, parse: { (raw: [String : String]) -> RealmOfflineProduct? in
                                            guard let barcode = raw["code"] else { return nil }

                                            let product = RealmOfflineProduct()
                                            product.barcode = barcode
                                            product.name = raw["product_name"]
                                            product.quantity = raw["quantity"]
                                            product.brands = raw["brands"]
                                            product.nutritionGrade = raw["nutrition_grade_fr"]
                                            product.novaGroup = raw["nova_group"]

                                            return product
                                        }, treatBatch: { (products: [RealmOfflineProduct]) in
                                            self.persistenceManager.save(offlineProducts: products)
                                            totalCount += products.count
                                            log.debug("[Offline_products] Treated \(totalCount) / \(totalProductsCount) products")
                                            self.persistenceManager.updateOfflineProductStatus(percent: Double(totalCount) / Double(totalProductsCount) * 100, savedProductsCount: totalCount)
                                        })

                                        log.info("[Offline_products] We just saved \(totalCount) products for an offline save !")
                                        success = totalCount > 0

                                        self.persistenceManager.updateOfflineProductStatus(percent: 100, savedProductsCount: totalCount)
                                    }
                                } else {
                                    success = false
                                }

                                OfflineProductsService.deleteFile(atURL: unzipedFolderPath)
                            } catch let error {
                                log.error("[Offline_products] Error listing unzipped files! \(error)")
                                Crashlytics.sharedInstance().recordError(error)
                                success = false
                            }
                            OfflineProductsService.deleteFile(atURL: localFilePath)
                            completion(success)
                        }
                    })
        }
    }

    func refreshOfflineProductsFromServerIfNeeded(force: Bool = false) {
        let lastDownload = UserDefaults.standard.double(forKey: OfflineProductsService.USER_DEFAULT_LAST_OFFLINE_PRODUCTS_DOWNLOAD)

        let shouldDownload = lastDownload == 0 || (Date().timeIntervalSince1970 - OfflineProductsService.LAST_DOWNLOAD_DELAY) > lastDownload

        if shouldDownload {

            let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

            let startTime = CFAbsoluteTimeGetCurrent()
            downloadFile { (success) in
                if success {
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: OfflineProductsService.USER_DEFAULT_LAST_OFFLINE_PRODUCTS_DOWNLOAD)
                }

                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                log.info("[Offline_products] sync took \(timeElapsed) seconds")

                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        } else {
            log.debug("Do not download offline products, we already have them !")
        }
    }
}
