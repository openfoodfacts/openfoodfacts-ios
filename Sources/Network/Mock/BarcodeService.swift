//
//  BarcodeService.swift
//  OpenFoodFacts
//
//  Created by Clément Aubin on 08/09/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import Alamofire
import AlamofireImage

protocol MockBarcodeApi {
    func getGenericBarcodeImage(forLocale locale: Locale, onSuccess: @escaping (Image) -> Void, onError: @escaping (Error) -> Void)
}

class MockBarcodeService: MockBarcodeApi {
    func getGenericBarcodeImage(forLocale locale: Locale, onSuccess: @escaping (Image) -> Void,
                                onError: @escaping (Error) -> Void) {

        let url = URLs.MockBarcode + locale.identifier + ".jpg"
        Alamofire.request(url).responseImage { response in
            response.result.ifFailure {
                onError(response.result.error!)
            }
            response.result.ifSuccess {
                onSuccess(response.result.value!)
            }
        }
    }
}
