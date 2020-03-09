@testable import OpenFoodFacts
import UIKit

// This extension provides initializers for the ProductImage used during testing,
// to give default values to the init parameters

extension ProductImage {
    init?(barcode: String, image: UIImage, type: ImageType) {
        self.init(barcode: barcode, image: image, type: type, languageCode: "en")
    }

    init?(barcode: String, fileName: String, type: ImageType) {
        self.init(barcode: barcode, fileName: fileName, type: type, languageCode: "en")
    }
}
