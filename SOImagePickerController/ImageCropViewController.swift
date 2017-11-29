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

    @IBOutlet private var editParentView: UIView!
    @IBOutlet private var editImageView: UIImageView!
    @IBOutlet private var cropView: UIView!
    
    @IBOutlet private var editImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var cropViewHeightConstraint: NSLayoutConstraint!
    
    private var editImage:UIImage?{
        get{
            return self.editImageView.image
        }
        set{
            self.editImageView.image = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cropView.layer.borderWidth = 1.0
        self.cropView.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.7215686275, blue: 0.831372549, alpha: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.editImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let realSize = self.editImage?.size{
            let aspect = realSize.height / realSize.width
            
            let height = self.editParentView.bounds.size.height
            
            let width = height / aspect
            
            print(realSize)
            
            self.editImageViewWidthConstraint?.constant = width
        }
        
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction private func selectPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    @IBAction private func flipPhoto(_ sender:UIButton){
        if let realEditImage = self.editImage, let realCGImage = realEditImage.cgImage{
            self.editImage = self.editImage?.flipHorizontal()
        }
    }
    
    @IBAction func cropVertical(_ sender:UIButton){
        self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.height
    }
    
    @IBAction func cropSquare(_ sender:UIButton){
        self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.width / 2.0
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
}
