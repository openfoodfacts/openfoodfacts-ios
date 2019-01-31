//
//  ProductImageSpec.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 01/01/2018.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

class ProductImageSpec: QuickSpec {
    override func spec() {
        var productImage: ProductImage?
        describe(".init") {
            describe("when image can not be saved") {
                beforeEach {
                    productImage = ProductImage(barcode: "1", image: UIImage(), type: .front)
                }

                it("returns nil on init") {
                    expect(productImage).to(beNil())
                }
            }

            describe("when image can be saved") {
                beforeEach {
                    productImage = ProductImage(barcode: "1", image: TestHelper.sharedInstance.getTestImage(), type: .front)
                }

                it("returns instance") {
                    expect(productImage).toNot(beNil())
                }
            }

            describe("when image can be loaded") {
                beforeEach {
                    guard let fileName = self.saveTestImage() else { return }
                    productImage = ProductImage(barcode: "1", fileName: fileName, type: .front)
                }

                it("returns instance") {
                    expect(productImage).toNot(beNil())
                }
            }

            describe("when image can not be loaded") {
                beforeEach {
                    productImage = ProductImage(barcode: "1", fileName: "404.jpg", type: .front)
                }

                it("returns nil on init") {
                    expect(productImage).to(beNil())
                }
            }
        }

        describe(".deleteImage") {
            var testImageFileName: String?
            beforeEach {
                guard let fileName = self.saveTestImage() else { return }
                testImageFileName = fileName
                productImage = ProductImage(barcode: "1", fileName: fileName, type: .front)
                productImage?.deleteImage()
            }

            it("deletes image from device") {
                expect(self.checkImageExists(fileName: testImageFileName!)).to(beFalse())
            }
        }
    }

    private func saveTestImage() -> String? {
        let fileName = "test_image.jpg"
        do {
            guard let data = UIImageJPEGRepresentation(TestHelper.sharedInstance.getTestImage(), 1.0) else {
                XCTFail("Failed to get test image representation")
                return nil
            }
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent(fileName)
            try data.write(to: imageURL)
            return fileName
        } catch {
            XCTFail("Failed to store test image")
            return nil
        }
    }

    private func checkImageExists(fileName: String) -> Bool? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageURL = documentsURL.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: imageURL.path)
    }
}
