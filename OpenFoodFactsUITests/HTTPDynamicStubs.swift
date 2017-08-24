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
    let jsonFilename: String
    let method: HTTPMethod
}

let initialStubs = [
    HTTPStubInfo(url: "/cgi/search.pl?search_terms=fanta&search_simple=1&action=process&json=1&page=1", jsonFilename: "GET_ProductsByName_200", method: .GET),
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
            setupStub(url: stub.url, filename: stub.jsonFilename, method: stub.method)
        }
    }

    public func setupStub(url: String, filename: String, method: HTTPMethod = .GET) {
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: filename, ofType: "json")
        let fileUrl = URL(fileURLWithPath: filePath!)
        let data = try! Data(contentsOf: fileUrl, options: .uncached)
        // Looking for a file and converting it to JSON
        let json = dataToJSON(data: data)

        // Swifter makes it very easy to create stubbed responses
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            return HttpResponse.ok(.json(json as AnyObject))
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
