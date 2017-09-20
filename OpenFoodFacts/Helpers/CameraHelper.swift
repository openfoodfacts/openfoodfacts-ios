//
//  CameraHelper.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 20/09/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import MobileCoreServices

enum MediaType: String {
    case image = "public.image"
}

protocol CameraHelperProtocol {
    func getImagePickerForTaking(_ mediaType: MediaType) -> UIImagePickerController?
}

class CameraHelper: CameraHelperProtocol {

    func getImagePickerForTaking(_ mediaType: MediaType) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return nil }
        guard UIImagePickerController.availableMediaTypes(for: .camera)?.index(of: mediaType.rawValue) != nil else { return nil }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [mediaType.rawValue]
        return picker
    }
}
