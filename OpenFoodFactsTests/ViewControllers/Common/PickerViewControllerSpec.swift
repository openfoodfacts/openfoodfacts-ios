//
//  PickerViewControllerSpec.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 08/12/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts
import Quick
import Nimble

// swiftlint:disable force_cast
// swiftlint:disable function_body_length
class PickerViewControllerSpec: QuickSpec {
    override func spec() {
        let langs = [Language(code: "en", name: "English"), Language(code: "es", name: "Spanish")]
        let defaultValue = 1 // zero-indexed
        var delegate: PickerViewDelegateMock!
        var viewController: PickerViewController!

        beforeEach {
            delegate = PickerViewDelegateMock()
            viewController = PickerViewController(data: langs, defaultValue: defaultValue, delegate: delegate)
        }

        describe("loadView") {
            it("creates UIPickerView") {
                viewController.loadView()
                expect(viewController.view is UIPickerView).to(beTrue())
            }

            it("sets the dataSource") {
                viewController.loadView()
                expect((viewController.view as! UIPickerView).dataSource is PickerViewController).to(beTrue())
            }

            it("sets the delegate") {
                viewController.loadView()
                expect((viewController.view as! UIPickerView).delegate is PickerViewController).to(beTrue())
            }
        }

        describe("viewDidLoad") {
            var pickerViewMock: UIPickerViewMock!

            beforeEach {
                pickerViewMock = UIPickerViewMock()
            }

            it("does not select a row when there is no default value") {
                viewController = PickerViewController(data: langs)
                viewController.view = pickerViewMock
                viewController.viewDidLoad()
                expect(pickerViewMock.selectRowCalled).to(beFalse())
            }

            it("it does not select a row when view is not picker view") {
                viewController = PickerViewController(data: langs, defaultValue: defaultValue, delegate: nil)
                viewController.view = UILabel()
                viewController.viewDidLoad()
                expect(pickerViewMock.selectRowCalled).to(beFalse())
            }

            it("selects a row when there's a default value and view is picker view") {
                viewController = PickerViewController(data: langs, defaultValue: defaultValue, delegate: nil)
                viewController.view = pickerViewMock
                viewController.viewDidLoad()
                expect(pickerViewMock.selectRowCalled).to(beTrue())
                expect(pickerViewMock.selectedRow).to(equal(defaultValue))
            }
        }

        context("viewController view is loaded") {
            beforeEach {
                UIApplication.shared.keyWindow!.rootViewController = viewController
                expect(viewController.view).toNot(beNil())
            }

            describe("viewDidLoad") {
                it("sets the default value") {
                    let picker = viewController.view as! UIPickerView
                    expect(picker.selectedRow(inComponent: 0)).toEventually(equal(defaultValue), timeout: 10)
                }
            }
        }

        describe("picker datasource") {
            var picker: UIPickerView!

            beforeEach {
                picker = viewController.view as! UIPickerView
            }

            describe("numberOfComponents") {
                it("returns but one component") {
                    expect(viewController.numberOfComponents(in: picker)).to(equal(1))
                }
            }

            describe("numberOfRowsInComponent") {
                it("returns number of langs") {
                    expect(viewController.pickerView(picker, numberOfRowsInComponent: 0)).to(equal(langs.count))
                }
            }
        }

        describe("picker delegate") {
            var picker: UIPickerView!
            let component = 0

            beforeEach {
                picker = viewController.view as! UIPickerView
            }

            describe("titleForRow") {
                it("returns language name") {
                    expect(viewController.pickerView(picker, titleForRow: 0, forComponent: component)).to(equal(langs[0].name))
                }
            }

            describe("didSelectRow") {
                it("calls picker view delegate with value") {
                    viewController.pickerView(picker, didSelectRow: langs.count - 1, inComponent: component)
                    expect(delegate.didGetSelectionCalled).to(beTrue())
                    XCTAssertEqual(delegate.selected, langs[langs.count - 1])
                }
            }
        }
    }
}

class UIPickerViewMock: UIPickerView {
    var selectRowCalled = false
    var selectedRow = -1

    override func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        selectRowCalled = true
        selectedRow = row
    }
}
