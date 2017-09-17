//
//  HTTPDynamicStubs.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 23/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import Swifter

enum HTTPMethod {
    case POST
    case GET
}

struct HTTPStubInfo {
    let url: String
    let jsonFilename: String?
    let method: HTTPMethod

    init(url: String, jsonFilename: String? = nil, method: HTTPMethod) {
        self.url = url
        self.jsonFilename = jsonFilename
        self.method = method
    }
}

let initialStubs = [
    HTTPStubInfo(url: "/cgi/search.pl", jsonFilename: "GET_ProductsByNameSinglePage_200", method: .GET)
]

class HTTPDynamicStubs {

    var server = HttpServer()

    func setUp() {
        setupInitialStubs()
        try! server.start()
    }

    func tearDown() {
        server.stop()
    }

    func setupInitialStubs() {
        // Setting up all the initial mocks from the array
        for stub in initialStubs {
            if let jsonFilename = stub.jsonFilename {
                setupStub(url: stub.url, filename: jsonFilename, method: stub.method)
            } else {
                setupErrorStub(url: stub.url)
            }
        }
    }

    public func setupStub(url: String, filename: String, method: HTTPMethod = .GET) {
        let testBundle = Bundle(for: Swift.type(of: self))
        let filePath = testBundle.path(forResource: filename, ofType: "json")
        let fileUrl = URL(fileURLWithPath: filePath!)
        let data = try! Data(contentsOf: fileUrl, options: .uncached)
        let json = dataToJSON(data: data)

        let response: ((HttpRequest) -> HttpResponse) = { _ in
            return HttpResponse.ok(.json(json as AnyObject))
        }

        switch method  {
        case .GET : server.GET[url] = response
        case .POST: server.POST[url] = response
        }
    }

    public func setupErrorStub(url: String, method: HTTPMethod = .GET) {
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            return HttpResponse.internalServerError
        }

        switch method  {
        case .GET : server.GET[url] = response
        case .POST: server.POST[url] = response
        }
    }

    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
