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
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var lastCodeScanned: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            // TODO Show error
        })
    }
}
