//
//  PendingProductMergeProcessorSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 01/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable function_body_length
class PendingProductMergeProcessorSpec: QuickSpec {
    override func spec() {
        let barcode = "1"
        let name = "product_name"
        let brand = "brand"
        let quantity = "33cl"
        let language = "de"

        var processor: ProductMergeProcessor?

        beforeEach {
            processor = PendingProductMergeProcessor()
        }

        context("when product is complete") {
            var result: (product: Product?, nutriments: [RealmPendingUploadNutrimentItem]?)?

            beforeEach {
                let item = PendingUploadItem(barcode: barcode)

                var product = Product()
                product.barcode = barcode
                product.name = name
                product.brands = [brand]
                product.quantity = quantity
                product.lang = language

                result = processor?.merge(item, product)
            }

            it("returns nil") {
                expect(result?.product).to(beNil())
            }
        }

        context("when product is empty") {
            var item: PendingUploadItem!
            var result: (product: Product?, nutriments: [RealmPendingUploadNutrimentItem]?)?

            beforeEach {
                item = PendingUploadItem(barcode: barcode)
                item.productName = name
                item.brand = brand
                item.quantity = quantity
                item.language = language

                let product = Product()

                result = processor?.merge(item, product)
            }

            it("returns product with item's info") {
                expect(result?.product?.barcode).to(equal(item.barcode))
                expect(result?.product?.name).to(equal(item.productName))
                expect(result?.product?.brands).to(equal([item.brand]))
                expect(result?.product?.quantity).to(equal(item.quantity))
                expect(result?.product?.lang).to(equal(item.language))
            }
        }

        context("when product is partially complete") {
            var item: PendingUploadItem!
            var result: (product: Product?, nutriments: [RealmPendingUploadNutrimentItem]?)?

            beforeEach {
                item = PendingUploadItem(barcode: barcode)
                item.productName = name
                item.brand = brand
                item.quantity = quantity
                item.language = language

                var product = Product()
                product.name = "another_name"

                result = processor?.merge(item, product)
            }

            it("returns product with empty properties filled with item's info") {
                expect(result?.product?.barcode).to(equal(item.barcode))
                expect(result?.product?.name).to(beNil())
                expect(result?.product?.brands).to(equal([item.brand]))
                expect(result?.product?.quantity).to(equal(item.quantity))
                expect(result?.product?.lang).to(equal(item.language))
            }
        }
    }
}
