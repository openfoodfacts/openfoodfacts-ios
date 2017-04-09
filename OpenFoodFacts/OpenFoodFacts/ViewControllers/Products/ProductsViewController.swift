//
//  ProductsViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 09/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProductsViewController: UIViewController {
    
    lazy var cameraController = CameraViewController() as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressTakePictureButton(_ sender: UIButton) {
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
        picker.delegate = cameraController
        self.present(picker, animated: true, completion: nil)
    }
}
