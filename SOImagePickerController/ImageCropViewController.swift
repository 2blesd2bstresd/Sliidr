//
//  ViewController.swift
//  SOImagePickerController
//
//  Created by myCompany on 9/6/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import Photos



class ImageCropViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet private var editImageView: UIImageView!
    @IBOutlet private var cropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cropView.layer.borderWidth = 1.0
        self.cropView.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.7215686275, blue: 0.831372549, alpha: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //Action for capture image from Camera
    @IBAction func actionClickOnCamera(_ sender: AnyObject) {
        //This condition is used for check availability of camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true;
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "You don't have a camera for this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.editImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    // MARK: - Actions
    @IBAction func selectPhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        self.editImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
////        print("UI IMAGE")
////        print(imgView)
////        for i in splitImage(image2D: imgView.image!) {
////            self.saveImageToCameraRoll(i)
////        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    func splitImage(image2D: UIImage) -> [UIImage] {
        let imgWidth = image2D.size.width / 2
        let imgHeight = image2D.size.height
        var imgImages:[UIImage] = []
        
        let leftHigh = CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight)
        let rightHigh = CGRect(x: imgWidth, y: 0, width: imgHeight, height: imgHeight)
//        let leftLow = CGRect(x: 0, y: imgHeight, width: imgWidth, height: imgHeight)
//        let rightLow = CGRect(x: imgWidth, y: imgHeight, width: imgWidth, height: imgHeight)
        
        let leftQH = image2D.cgImage?.cropping(to:leftHigh)
        let rightHQ = image2D.cgImage?.cropping(to:rightHigh)
//        let leftQL = image2D.cgImage?.cropping(to:leftLow)
//        let rightQL = image2D.cgImage?.cropping(to:rightLow)
        
        imgImages.append(UIImage(cgImage: leftQH!))
        imgImages.append(UIImage(cgImage: rightHQ!))
//        imgImages.append(UIImage(cgImage: leftQL!))
//        imgImages.append(UIImage(cgImage: rightQL!))
        
        return imgImages
    }
    
    func saveImageToCameraRoll(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                // Saved successfully!
            }
            else if let error = error {
                print("Save failed with error " + String(describing: error))
            }
            else {
            }
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        imgView.image = image
//        dismissViewControllerAnimated(true, completion: nil)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

