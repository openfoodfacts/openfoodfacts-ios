//
//  PictureTableViewControllerTests.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 09/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import XCTest
@testable import OpenFoodFacts
import Nimble

// swiftlint:disable force_cast
class PictureTableViewControllerTests: XCTestCase {
    var viewController: PictureTableViewController!
    var navigationController: UINavigationControllerMock!
    var productApi: ProductServiceMock!
    var cameraControllerMock: CameraControllerMock!

    override func setUp() {
        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: String(describing: PictureTableViewController.self)) as! PictureTableViewController
        navigationController = UINavigationControllerMock(rootViewController: viewController)

        productApi = ProductServiceMock()
        viewController.productApi = productApi

        cameraControllerMock = CameraControllerMock()
        viewController.cameraController = cameraControllerMock

        UIApplication.shared.keyWindow!.rootViewController = navigationController

        expect(self.navigationController.view).notTo(beNil())
        expect(self.viewController.view).notTo(beNil())
    }

    // MARK: - viewDidLoad
    func testViewDidLoad() {
        viewController.viewDidLoad()

        expect(self.viewController.tableView.isScrollEnabled).to(beFalse())
        expect(self.viewController.pictures.count).to(equal(3))
        expect(self.viewController.currentPictureForCell).to(beNil())
    }

    // MARK: - didTapCellTakePictureButton
    func testDidTapCellTakePictureButton() {
        expect(self.viewController.tableView.visibleCells.count).toEventuallyNot(equal(0), timeout: 10)
        let cell = viewController.tableView.visibleCells[0] as! PictureTableViewCell
        let cellButton = cell.pictureButton!

        viewController.didTapCellTakePictureButton(cellButton)

        expect(self.viewController.imageType).to(equal(viewController.pictures[0].imageType))
        expect(self.cameraControllerMock.isShowing).to(beTrue())
    }

    func testDidTapCellTakePictureButtonShouldDoNothingWhenCellNotFound() {
        let cellButton = UIButton()

        viewController.didTapCellTakePictureButton(cellButton)

        expect(self.cameraControllerMock.isShowing).to(beFalse())
    }

    func testDidTapCellTakePictureButtonShouldDoNothingWhenIndexPathNotFound() {
        let cell = PictureTableViewCell()
        let firstParent = UIView()
        let secondParent = UIView()
        let thirdParent = UIView()
        let cellButton = UIButton()
        firstParent.addSubview(cellButton)
        secondParent.addSubview(firstParent)
        thirdParent.addSubview(secondParent)
        cell.addSubview(thirdParent)

        viewController.didTapCellTakePictureButton(cellButton)

        expect(self.cameraControllerMock.isShowing).to(beFalse())
    }

    // MARK: - numberOfSections
    func testNumberOfSections() {
        let result = viewController.numberOfSections(in: viewController.tableView)

        expect(result).to(equal(1))
    }

    // MARK: - numberOfRowsInSection
    func testNumberOfRowsInSection() {
        let section = 0

        let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: section)

        expect(result).to(equal(3))
    }

    // MARK: - cellForRowAt
    func testCellForRowAt() {
        let indexPath = IndexPath(row: 0, section: 0)

        let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)

        expect(cell is PictureTableViewCell).to(beTrue())
    }

    // MARK: - postImageSuccess
    func testPostImageSuccess() {
        let testImage = TestHelper.sharedInstance.getTestImage()
        viewController.currentPictureForCell = IndexPath(row: 0, section: 0)

        viewController.postImageSuccess(image: testImage)

        expect(self.viewController.pictures[0].image).to(equal(testImage))
        expect(self.viewController.currentPictureForCell).to(beNil())
    }

    func testPostImageSuccessShouldDoNothingWhenThereIsNoCurrentPictureCell() {
        let testImage = TestHelper.sharedInstance.getTestImage()
        viewController.currentPictureForCell = nil

        viewController.postImageSuccess(image: testImage)
        expect(self.viewController.pictures[0].image).to(beNil())
        expect(self.viewController.currentPictureForCell).to(beNil())
    }
}
