//
//  ProductServiceMock.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 17/08/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
@testable import OpenFoodFacts
import ObjectMapper

class ProductServiceMock: ProductApi {
    var query: String?
    var page: Int?
    var productsResponse: ProductsResponse!
    let error = NSError(domain:NSURLErrorDomain, code:-1009, userInfo: nil)
    var productImage: ProductImage?
    var product: Product!

    func getProducts(for query: String, page: Int, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
        self.query = query
        self.page = page

        if "Fanta" == query {
            onSuccess(productsResponse)
        } else {
            onError(error)
        }
    }

    func getProduct(byBarcode barcode: String, onSuccess: @escaping (ProductsResponse) -> Void, onError: @escaping (Error) -> Void) {
    }

    func postImage(_ productImage: ProductImage, barcode: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.productImage = productImage

        if "123456789" == barcode {
            onSuccess()
        } else {
            onError(error)
        }
    }

    func postProduct(_ product: Product, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.product = product

        if "123456789" == product.barcode {
            onSuccess()
        } else {
            onError(error)
        }
    }
}
