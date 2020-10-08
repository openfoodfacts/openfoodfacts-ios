import Foundation
import Alamofire

/**
 The `TaxonomiesRequest` struct Represents the data structure for a taxonomies request
 */
struct TaxonomiesRequest: URLRequestConvertible {
    private let route: TaxonomiesRoute
    private let requestType: HTTPMethod
    private let errorDomain = "Taxonomies url could not be constructed"

    init(route: TaxonomiesRoute, requestType: HTTPMethod) {
        self.route = route
        self.requestType = requestType
    }

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw NSError(domain: errorDomain, code: Errors.codes.generic.rawValue, userInfo: ["path": path])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        return urlRequest
    }

    private var path: String {
        switch (requestType, route) {
        case (.get, .getIngredientsAnalysisConfig):
            return route.rawValue + "/data/" + Endpoint.get
        case (.post, _):
            return Endpoint.post + route.rawValue
        case (.get, _):
            return Endpoint.get + "/data/" + route.rawValue
        default:
            return ""
        }
    }
}
