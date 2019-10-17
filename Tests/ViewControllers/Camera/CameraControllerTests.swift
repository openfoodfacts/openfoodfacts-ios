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

    func skiptestShowPresentsImagePicker() {
        cameraController.show()

        expect(self.presentingViewController.presentedViewController).toEventually(beAnInstanceOf(UIImagePickerController.self), timeout: 10)
    }

    func skip_testImagePickerControllerDidFinishPickingMediaWithInfo() {
        let testImage = TestHelper().getTestImage()
//        let info = [convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage): testImage]

//        cameraController.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: info)

        expect(self.cameraControllerDelegateMock?.gotImage).to(beTrue())
        expect(self.cameraControllerDelegateMock?.image).toEventually(equal(testImage))
    }

    func skiptestImagePickerControllerDidCancelDismissesImagePicker() {
        let imagePicker = UIImagePickerController()
        presentingViewController.present(imagePicker, animated: false, completion: nil)
        expect(self.presentingViewController.presentedViewController).toEventually(equal(imagePicker), timeout: 10)

        cameraController.imagePickerControllerDidCancel(imagePicker)

        expect(self.presentingViewController.presentedViewController).toEventually(beNil(), timeout: 10)
    }
}

class CameraControllerDelegateMock: NSObject, CameraControllerDelegate {
    var gotImage = false
    var image: UIImage?
    var imageType: ImageType?

    func didGetImage(image: UIImage, forImageType imageType: ImageType?) {
        gotImage = true
        self.image = image
    }
}

class CameraHelperMock: CameraHelperProtocol {
    func getImagePickerForTaking(_ mediaType: MediaType) -> UIImagePickerController? {
        return UIImagePickerController()
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
