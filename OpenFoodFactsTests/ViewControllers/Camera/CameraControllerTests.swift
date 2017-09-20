//
//  CameraControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 20/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

class CameraControllerTests: XCTestCase {
    var cameraController: CameraControllerImpl!
    let presentingViewController = UIViewController()
    let cameraHelperMock = CameraHelperMock()
    var cameraControllerDelegateMock: CameraControllerDelegateMock?

    override func setUp() {
        super.setUp()

        cameraControllerDelegateMock = CameraControllerDelegateMock()

        cameraController = CameraControllerImpl(presentingViewController: presentingViewController)
        cameraController.cameraHelper = cameraHelperMock
        cameraController.delegate = cameraControllerDelegateMock

        UIApplication.shared.keyWindow!.rootViewController = presentingViewController
    }

    func testShowPresentsImagePicker() {
        cameraController.show()

        expect(self.presentingViewController.presentedViewController).toEventually(beAnInstanceOf(UIImagePickerController.self))
    }

    func testImagePickerControllerDidFinishPickingMediaWithInfo() {
        let testImage = TestHelper().getTestImage()
        let info = [UIImagePickerControllerOriginalImage: testImage]

        cameraController.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: info)

        expect(self.cameraControllerDelegateMock?.gotImage).to(beTrue())
        expect(self.cameraControllerDelegateMock?.image).toEventually(equal(testImage))
    }

    func testImagePickerControllerDidCancelDismissesImagePicker() {
        let imagePicker = UIImagePickerController()
        presentingViewController.present(imagePicker, animated: false, completion: nil)
        expect(self.presentingViewController.presentedViewController).toEventually(equal(imagePicker))

        cameraController.imagePickerControllerDidCancel(imagePicker)

        expect(self.presentingViewController.presentedViewController).toEventually(beNil())
    }
}

class CameraControllerDelegateMock: NSObject, CameraControllerDelegate {
    var gotImage = false
    var image: UIImage?

    func didGetImage(image: UIImage) {
        gotImage = true
        self.image = image
    }
}

class CameraHelperMock: CameraHelperProtocol {
    func getImagePickerForTaking(_ mediaType: MediaType) -> UIImagePickerController? {
        return UIImagePickerController()
    }
}
