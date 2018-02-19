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
        let quantityValue = "33"
        let quantityUnit = "cl"
        let language = "de"

        var processor: ProductMergeProcessor?

        beforeEach {
            processor = PendingProductMergeProcessor()
        }

        context("when product is complete") {
            var result: Product?

            beforeEach {
                let item = PendingUploadItem(barcode: barcode)

                var product = Product()
                product.barcode = barcode
                product.name = name
                product.brands = [brand]
                product.quantityValue = quantityValue
                product.quantityUnit = quantityUnit
                product.lang = language

                result = processor?.merge(item, product)
            }

            it("returns nil") {
                expect(result).to(beNil())
            }
        }

        context("when product is empty") {
            var item: PendingUploadItem!
            var result: Product?

            beforeEach {
                item = PendingUploadItem(barcode: barcode)
                item.productName = name
                item.brand = brand
                item.quantityValue = quantityValue
                item.quantityUnit = quantityUnit
                item.language = language

                let product = Product()

                result = processor?.merge(item, product)
            }

            it("returns product with item's info") {
                expect(result?.barcode).to(equal(item.barcode))
                expect(result?.name).to(equal(item.productName))
                expect(result?.brands).to(equal([item.brand]))
                expect(result?.quantityValue).to(equal(item.quantityValue))
                expect(result?.quantityUnit).to(equal(item.quantityUnit))
                expect(result?.lang).to(equal(item.language))
            }
        }

        context("when product is partially complete") {
            var item: PendingUploadItem!
            var result: Product?

            beforeEach {
                item = PendingUploadItem(barcode: barcode)
                item.productName = name
                item.brand = brand
                item.quantityValue = quantityValue
                item.quantityUnit = quantityUnit
                item.language = language

                var product = Product()
                product.name = "another_name"

                result = processor?.merge(item, product)
            }

            it("returns product with empty properties filled with item's info") {
                expect(result?.barcode).to(equal(item.barcode))
                expect(result?.name).to(beNil())
                expect(result?.brands).to(equal([item.brand]))
                expect(result?.quantityValue).to(equal(item.quantityValue))
                expect(result?.quantityUnit).to(equal(item.quantityUnit))
                expect(result?.lang).to(equal(item.language))
            }
        }
    }
}
