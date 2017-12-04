//
//  ScannerViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import AVFoundation
import Crashlytics
import NotificationBanner
import SVProgressHUD

class ScannerViewController: UIViewController {
    fileprivate let supportedBarcodes = [AVMetadataObject.ObjectType.upce,
                                         AVMetadataObject.ObjectType.code39,
                                         AVMetadataObject.ObjectType.code39Mod43,
                                         AVMetadataObject.ObjectType.code93,
                                         AVMetadataObject.ObjectType.code128,
                                         AVMetadataObject.ObjectType.ean8,
                                         AVMetadataObject.ObjectType.ean13,
                                         AVMetadataObject.ObjectType.pdf417,
                                         AVMetadataObject.ObjectType.itf14,
                                         AVMetadataObject.ObjectType.interleaved2of5]

    fileprivate var session = AVCaptureSession()
    fileprivate var barcodeQueue = DispatchQueue(label: "barcode queue")
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate lazy var flashButton = FlashButton()
    fileprivate lazy var overlay = TextOverlay()
    fileprivate var tapToFocusView: TapToFocusView?
    fileprivate var lastCodeScanned: String?
    fileprivate var showHelpInOverlayTask: DispatchWorkItem?
    let productApi: ProductApi
    var configResult: SessionConfigResult = .success

    init(productApi: ProductApi) {
        self.productApi = productApi
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoView()

        checkCameraPermissions()
        configureSession()
        configureFlashView()
        configureOverlay()
        configureTapToFocus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastCodeScanned = nil
        resetOverlay()

        switch configResult {
        case .success:
            session.startRunning()
        case .noPermissions:
            requestPermissions()
        case .failed:
            returnToRootController()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
        showHelpInOverlayTask?.cancel()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.videoPreviewLayer?.connection?.videoOrientation = self.transformOrientation()
            self.videoPreviewLayer?.frame = self.view.bounds
        }, completion: nil)
    }

    fileprivate func transformOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }

    private func configureVideoView() {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = self.view.layer.bounds
        self.videoPreviewLayer = videoPreviewLayer
        self.view.layer.addSublayer(videoPreviewLayer)
    }

    fileprivate func configureSession() {
        if configResult != .success {
            return
        }

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            configResult = .failed
            handleNoCamera()
            return
        }

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            session.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: barcodeQueue)
            captureMetadataOutput.metadataObjectTypes = supportedBarcodes
        } catch {
            configResult = .failed
            Crashlytics.sharedInstance().recordError(error)
            return
        }
    }

    fileprivate func configureFlashView() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            flashButton.translatesAutoresizingMaskIntoConstraints = false
            flashButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFlashButton(_:))))
            self.view.addSubview(flashButton)

            let bottomConstraint = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .top, relatedBy: .equal, toItem: flashButton, attribute: .bottom, multiplier: 1, constant: 15)
            let leftConstraint = NSLayoutConstraint(item: flashButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 15)

            self.view.addConstraints([bottomConstraint, leftConstraint])
        }
    }

    fileprivate func configureOverlay() {
        self.view.addSubview(overlay)

        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: overlay, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[overlay]-0-|", options: [], metrics: nil, views: ["overlay": overlay])

        self.view.addConstraints(constraints)

        resetOverlay()
    }

    fileprivate func resetOverlay() {
        overlay.setText("product-scanner.overlay.user-help".localized)
        showHelpInOverlayTask?.cancel()
        showScanHelpInstructions()
    }

    fileprivate func showScanHelpInstructions() {
        let task = DispatchWorkItem {
            if self.lastCodeScanned == nil {
                self.overlay.setText("product-scanner.overlay.extended-user-help".localized)
            } else {
                self.showScanHelpInstructions()
            }
        }

        self.showHelpInOverlayTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: task)
    }

    fileprivate func configureTapToFocus() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToFocus(_:))))
    }

    private func handleNoCamera() {
        let error = NSError(domain: "ScannerViewControllerErrorDomain", code: 1, userInfo: ["errorType": "No camera found"])
        Crashlytics.sharedInstance().recordError(error)
    }
}

// MARK: - AVCapture delegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            return
        }

        if let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, supportedBarcodes.contains(metadataObject.type), let barcode = metadataObject.stringValue {
            if lastCodeScanned == nil || (lastCodeScanned != nil && lastCodeScanned != barcode) {
                session.stopRunning()
                lastCodeScanned = barcode
                getProduct(barcode: barcode)
            }
        }
    }

    func getProduct(barcode: String) {
        DispatchQueue.main.async {
            let productLoadingMessage = "product-scanner.search.status".localized
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show(withStatus: productLoadingMessage)
        }

        productApi.getProduct(byBarcode: barcode, isScanning: true, onSuccess: { response in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            if let product = response {
                self.showProduct(product)
            } else {
                self.addNewProduct(barcode)
            }
        }, onError: { _ in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                StatusBarNotificationBanner(title: "product-scanner.barcode.error".localized, style: .danger).show()
            }

            self.lastCodeScanned = nil
            self.session.startRunning()
        })
    }
}

// MARK: - Gesture recognizers
extension ScannerViewController {
    @objc func didTapFlashButton(_ gesture: UITapGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            try device.lockForConfiguration()
            switch flashButton.state {
            case .on:
                flashButton.state = .off
                device.torchMode = .off
            case .off:
                flashButton.state = .on
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    Crashlytics.sharedInstance().recordError(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    @objc func didTapToFocus(_ gesture: UITapGestureRecognizer) {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.isFocusPointOfInterestSupported, let videoPreviewLayer = self.videoPreviewLayer {
            let touchPoint = gesture.location(in: self.view)

            let tapToFocusView = self.tapToFocusView ?? TapToFocusView()

            if self.tapToFocusView == nil {
                self.tapToFocusView = tapToFocusView
                self.view.addSubview(tapToFocusView)
            }

            tapToFocusView.updateCenter(touchPoint)

            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            } catch {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }
}

// MARK: - Navigation

extension ScannerViewController {
    func showProduct(_ product: Product) {
        let storyboard = UIStoryboard(name: String(describing: ProductDetailViewController.self), bundle: nil)
        // swiftlint:disable:next force_cast
        let productDetailVC = storyboard.instantiateInitialViewController() as! ProductDetailViewController
        productDetailVC.product = product
        productDetailVC.productApi = productApi

        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }

    func addNewProduct(_ barcode: String) {
        turnOffFlash()

        let storyboard = UIStoryboard(name: String(describing: ProductAddViewController.self), bundle: nil)
        if let addProductVC = storyboard.instantiateInitialViewController() as? ProductAddViewController {
            addProductVC.barcode = barcode
            addProductVC.productApi = productApi
            self.navigationController?.pushViewController(addProductVC, animated: true)
        }
    }

    fileprivate func turnOffFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if flashButton.state == .on {
            do {
                try device.lockForConfiguration()
                flashButton.state = .off
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }
}

// MARK: - Permissions

extension ScannerViewController {
    enum SessionConfigResult {
        case success, noPermissions, failed
    }

    private func checkCameraPermissions() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.configResult = .failed
            returnToRootController()
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            barcodeQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.configResult = .failed
                }
                self.barcodeQueue.resume()
            })
        default:
            self.configResult = .noPermissions
        }
    }

    private func requestPermissions() {
        let title = "product-scanner.permissions.noPermissions.title".localized
        let message = "product-scanner.permissions.noPermissions.message".localized
        let actionTitle = "product-scanner.permissions.noPermissions.action.title".localized

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.openURL(settingsURL)
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func returnToRootController() {
        let title = "product-scanner.permissions.failed.title".localized
        let message = "product-scanner.permissions.failed.message".localized
        let actionTitle = "product-scanner.permissions.failed.action.title".localized

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
