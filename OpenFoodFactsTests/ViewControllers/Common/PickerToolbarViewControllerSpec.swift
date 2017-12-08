//
//  PickerToolbarViewControllerSpec.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 08/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

class PickerToolbarViewControllerSpec: QuickSpec {
    override func spec() {
        let title = "title"
        var viewController: PickerToolbarViewController!
        var delegate: PickerViewDelegateMock!

        context("init without delegate") {
            beforeEach {
                viewController = PickerToolbarViewController(title: title)
            }

            describe("loadView") {
                it("creates view") {
                    viewController.loadView()

                    expect(viewController.view is UIToolbar).to(beTrue())
                    let toolbar = viewController.view as! UIToolbar // swiftlint:disable:this force_cast
                    expect(toolbar.isUserInteractionEnabled).to(beTrue())
                    expect(toolbar.items!.count).to(equal(4))
                }
            }
        }

        context("init with delegate") {
            beforeEach {
                delegate = PickerViewDelegateMock()
                viewController = PickerToolbarViewController(title: title, delegate: delegate)
            }

            describe("dismissPicker") {
                it("calls delegate") {
                    viewController.dismissPicker()
                    expect(delegate.didDismissCalled).to(beTrue())
                }
            }
        }
    }
}

extension UIBarButtonSystemItem: Equatable {

}
