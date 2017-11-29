//
//  ViewController.swift
//  SOImagePickerController
//
//  Created by myCompany on 9/6/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import Photos

enum ImageCropSegueIdentifier : String{
    case showPreview
}


class ImageCropViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropPreviewViewControllerDelegate {

    @IBOutlet private var editParentView: UIView!
    @IBOutlet private var editImageView: UIImageView!
    @IBOutlet private var cropView: UIView!
    
    @IBOutlet private var editImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var cropViewHeightConstraint: NSLayoutConstraint!
    
    private var cropSquare:Bool = false
    
    private var editImage:UIImage?{
        get{
            return self.editImageView.image
        }
        set{
            self.editImageView.image = newValue
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cropView.layer.borderWidth = 1.0
        self.cropView.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.7215686275, blue: 0.831372549, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifierString = segue.identifier, let segueIdentifier = ImageCropSegueIdentifier(rawValue:segueIdentifierString) else{
            super.prepare(for: segue, sender: sender)
            return
        }
        
        switch segueIdentifier {
        case .showPreview:
            let cropPreviewViewController = segue.destination as! CropPreviewViewController
            cropPreviewViewController.delegate = self
            
            let images = self.editImage?.cutoutSlides(cropSquare: self.cropSquare)
            
            cropPreviewViewController.image1 = images?.left
            cropPreviewViewController.image2 = images?.right
        }
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
    
    // MARK: - CropPreviewViewControllerDelegate
    
    func cropPreviewViewControllerCancel(_ cropPreviewViewController: CropPreviewViewController) {
        self.dismiss(animated: true)
    }
    
    func cropPreviewViewControllerComplete(_ cropPreviewViewController: CropPreviewViewController) {
        self.editImage = nil
        self.dismiss(animated: true) {
            let alert = UIAlertController(title: "Success!", message: "Your slides have been saved to your photos.", preferredStyle:.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
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
        self.editImage = self.editImage?.flipHorizontal()
    }
    
    @IBAction private func cropVertical(_ sender:UIButton){
        self.cropSquare = false
        
        self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.height
        self.animateLayout()
    }
    
    @IBAction private func cropSquare(_ sender:UIButton){
        self.cropSquare = true
        
        self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.width / 2.0
        self.animateLayout()
    }
    
    @IBAction private func previewCrop(_ sender:UIButton){
        if self.editImage != nil{
            self.performSegue(withIdentifier: ImageCropSegueIdentifier.showPreview.rawValue, sender: sender)
        }
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
    
//    func saveImageToCameraRoll(_ image: UIImage) {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAsset(from: image)
//        }, completionHandler: { success, error in
//            if success {
//                // Saved successfully!
//            }
//            else if let error = error {
//                print("Save failed with error " + String(describing: error))
//            }
//            else {
//            }
//        })
//    }
    
    // MARK: - Private
    
    private func animateLayout(){
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}
