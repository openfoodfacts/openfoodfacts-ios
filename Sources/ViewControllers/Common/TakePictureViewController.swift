//
//  TakePictureViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 29/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import NotificationBanner

class TakePictureViewController: UIViewController {
    var dataManager: DataManagerProtocol!
    var barcode: String?
    var imageType: ImageType = .front
    var languageCode: String = "xx"
    var cameraController: CameraController?

    // Feedback banners
    lazy var uploadingImageBanner: StatusBarNotificationBanner = {
        let banner = StatusBarNotificationBanner(title: "product-add.uploading-image-banner.title".localized, style: .info)
        banner.autoDismiss = false
        return banner
    }()
    lazy var uploadingImageErrorBanner: NotificationBanner = {
        let banner = NotificationBanner(title: "product-add.image-upload-error-banner.title".localized,
                                        subtitle: "product-add.image-upload-error-banner.subtitle".localized,
                                        style: .danger)
        return banner
    }()
    lazy var uploadingImageSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: "product-add.image-upload-success-banner.title".localized, style: .success)
        return banner
    }()
    lazy var productAddSuccessBanner: NotificationBanner = {
        let banner = NotificationBanner(title: "product-add.product-add-success-banner.title".localized, style: .success)
        return banner
    }()

    @IBAction func didTapTakePictureButton(_ sender: Any) {
        if self.cameraController == nil {
            self.cameraController = CameraControllerImpl(presentingViewController: self)
        }
        guard var cameraController = self.cameraController else { return }
        cameraController.delegate = self
        cameraController.languageCode = languageCode

        if let vcs = self as? SummaryHeaderCellController {
            cameraController.imageType = .front
            cameraController.languageCode = vcs.product.lang
        } else if let vcs = self as? IngredientsHeaderCellController {
            cameraController.imageType = .ingredients
            cameraController.languageCode = vcs.product.lang
        } else if let vcs = self as? NutritionTableHeaderCellController {
            cameraController.imageType = .nutrition
            cameraController.languageCode = vcs.product.lang
        } else {
            cameraController.imageType = self.imageType
        }
        cameraController.show()
    }

    func postImageSuccess(image: UIImage, forImageType imageType: ImageType) { /* Do nothing, overridable */ }

    func showUploadingImage(forType: ImageType? = .front, progress: Double?) {
        uploadingImageBanner.show()
    }

    func showErrorUploadingImage(forType: ImageType? = .front) {
        uploadingImageBanner.dismiss()
        uploadingImageErrorBanner.show()
    }

    func showSuccessUploadingImage(forType: ImageType? = .front) {
        uploadingImageBanner.dismiss()
        uploadingImageSuccessBanner.show()
    }
}

extension TakePictureViewController: CameraControllerDelegate {

    func didGetImage(image: UIImage, forImageType imageType: ImageType?, languageCode: String?) {
        // For now, images will be always uploaded with type front
        self.languageCode = languageCode ?? "ww"
        guard let validBarcode = barcode, let productImage = ProductImage(barcode: validBarcode, image: image, type: imageType ?? .general, languageCode: self.languageCode) else {
            showErrorUploadingImage(forType: imageType)
            return
        }

        dataManager.postImage(productImage, onSuccess: { [weak self] isOffline in
            if isOffline {
                self?.uploadingImageSuccessBanner.titleLabel?.text = "product-add.image-save-success-banner.title".localized
            } else {
                self?.uploadingImageSuccessBanner.titleLabel?.text = "product-add.image-upload-success-banner.title".localized
            }
            self?.showSuccessUploadingImage(forType: imageType)
            self?.postImageSuccess(image: image, forImageType: imageType ?? .front)
        }, onError: { [weak self] _ in
            self?.showErrorUploadingImage(forType: imageType)
        })
        showUploadingImage(forType: imageType, progress: nil)
    }
}
