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

class ScannerViewController: UIViewController {
    let supportedBarcodes = [AVMetadataObjectTypeUPCECode,
                             AVMetadataObjectTypeCode39Code,
                             AVMetadataObjectTypeCode39Mod43Code,
                             AVMetadataObjectTypeCode93Code,
                             AVMetadataObjectTypeCode128Code,
                             AVMetadataObjectTypeEAN8Code,
                             AVMetadataObjectTypeEAN13Code,
                             AVMetadataObjectTypePDF417Code,
                             AVMetadataObjectTypeITF14Code,
                             AVMetadataObjectTypeInterleaved2of5Code]
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate lazy var flashButton = FlashButton()
    fileprivate lazy var overlay = TextOverlay()
    
    fileprivate var lastCodeScanned: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVideoView()
        configureFlashView()
        configureOverlay()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.videoPreviewLayer?.connection.videoOrientation = self.transformOrientation()
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
        case .portrait:
            fallthrough
        default:
            return .portrait
        }
    }
    
    fileprivate func configureVideoView() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedBarcodes
            
            if let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer.frame = view.layer.bounds
                self.videoPreviewLayer = videoPreviewLayer
                view.layer.addSublayer(videoPreviewLayer)
            }
            
            captureSession?.startRunning()
        } catch {
            Crashlytics.sharedInstance().recordError(error)
            return
        }
    }
    
    fileprivate func configureFlashView() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            flashButton.translatesAutoresizingMaskIntoConstraints = false
            flashButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFlashButton(_:))))
            self.view.addSubview(flashButton)
            
            let bottomConstraint = NSLayoutConstraint(item: self.bottomLayoutGuide, attribute: .top, relatedBy: .equal, toItem: flashButton, attribute: .bottom, multiplier: 1, constant: 15)
            let leftConstraint = NSLayoutConstraint(item: flashButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 15)
            
            self.view.addConstraints([bottomConstraint, leftConstraint])
        }
    }
    
    fileprivate func configureOverlay() {
        overlay.set(text: NSLocalizedString("product-scanner.overlay.user-help", comment: "User help in the scan view"))
        self.view.addSubview(overlay)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: overlay, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[overlay]-0-|", options: [], metrics: nil, views: ["overlay": overlay])
        
        self.view.addConstraints(constraints)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.overlay.set(text: NSLocalizedString("product-scanner.overlay.extended-user-help", comment: "User help in the scan view"))
        })
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        if let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, supportedBarcodes.contains(metadataObject.type), let barcode = metadataObject.stringValue {
            if (lastCodeScanned == nil || (lastCodeScanned != nil && lastCodeScanned != barcode)) {
                lastCodeScanned = barcode
                getProduct(fromService: ProductService(), barcode: barcode)
            }
        }
    }
    
    func getProduct(fromService service: ProductService, barcode: String) {
        service.getProduct(byBarcode: barcode, onSuccess: { product in
            let storyboard = UIStoryboard(name: String(describing: ProductDetailViewController.self), bundle: nil)
            let productDetailVC = storyboard.instantiateInitialViewController() as! ProductDetailViewController
            productDetailVC.product = product
            
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }, onError: { error in
            Crashlytics.sharedInstance().recordError(error)
        })
    }
}

// MARK: - Gesture recognizers
extension ScannerViewController {
    func didTapFlashButton(_ gesture: UITapGestureRecognizer) {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        do {
            try device.lockForConfiguration()
            switch flashButton.state {
            case .on:
                flashButton.state = .off
                device.torchMode = .off
            case .off:
                flashButton.state = .on
                do {
                    try device.setTorchModeOnWithLevel(1.0)
                } catch {
                    Crashlytics.sharedInstance().recordError(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            Crashlytics.sharedInstance().recordError(error)
        }
    }
}
