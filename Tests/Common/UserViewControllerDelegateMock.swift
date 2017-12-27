//
//  UserViewControllerDelegateMock.swift
//  OpenFoodFactsTests
//
//  Created by Andrés Pizá Bückmann on 16/10/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

@testable import OpenFoodFacts

class UserViewControllerDelegateMock: UserViewControllerDelegate {
    var dismissCalled = false
    var showProductsPendingUploadCalled = false

    func dismiss() {
        dismissCalled = true
    }

    func showProductsPendingUpload() {
        showProductsPendingUploadCalled = true
    }
}
