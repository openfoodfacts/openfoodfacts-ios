//
//  CameraControllerMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 09/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
@testable import OpenFoodFacts

class CameraControllerMock: CameraController {
    weak var delegate: CameraControllerDelegate?
    var isShowing = false
    var imageType: ImageType?

    func show() {
        isShowing = true
    }
}
