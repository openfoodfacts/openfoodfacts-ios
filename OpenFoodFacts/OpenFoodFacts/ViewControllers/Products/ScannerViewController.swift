//
//  ScannerViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices

class ScannerViewController: UINavigationController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("No camera available... What to do?")
            return
        }
        
        let desiredType = String(kUTTypeImage)
        
        if UIImagePickerController.availableMediaTypes(for: .camera)?.index(of: desiredType) == nil {
            print("Can't capture")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(picker, animated: true, completion: nil)
    }
}

extension ScannerViewController: UIPickerViewDelegate {
    
}
