//
//  UIViewController+SelectPhoto.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/30/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

protocol PhotoSelector{
    func selectPhoto()
}

extension PhotoSelector where Self:UIViewController, Self:UIImagePickerControllerDelegate, Self:UINavigationControllerDelegate{
    func selectPhoto(){
        let alert = UIAlertController(title: "Select a Photo", message: "Do you want to take a picture or use an existing photo?", preferredStyle: .alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.selectPhotoForSourceType(.camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoRollAction = UIAlertAction(title: "Photos", style: .default) { (action) in
                self.selectPhotoForSourceType(.photoLibrary)
            }
            
            alert.addAction(photoRollAction)
        }
        
        if alert.actions.count == 0{
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true)
    }
    
    func selectPhotoForSourceType(_ sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
}
