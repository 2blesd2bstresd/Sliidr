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


class ImageCropViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, PhotoSelector, CropPreviewViewControllerDelegate {

    @IBOutlet private var editParentView: UIView!
    @IBOutlet private var editScrollView: UIScrollView!
    @IBOutlet private var editImageView: UIImageView!
    @IBOutlet private var editImageViewAspectConstraint: NSLayoutConstraint?
    @IBOutlet private var editImageViewConstantConstraint: NSLayoutConstraint?
    @IBOutlet private var cropView: UIView!
    
    @IBOutlet private var cropViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var cropVerticalButton: UIButton!
    @IBOutlet private var cropSquareButton: UIButton!
    
    private var cropSquare:Bool = false
    
    var editImage:UIImage?{
        didSet{
            self.editImageView?.image = editImage
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editImageView.image = self.editImage
        
        self.cropView.layer.borderWidth = 1.0
        self.cropView.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.7215686275, blue: 0.831372549, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateEditImageViewConstraints()
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
            
            let sizeMultiplier = (self.editImage?.size.width ?? self.editScrollView.contentSize.width) / self.editScrollView.contentSize.width
            let scaledOffset = CGPoint(x:self.editScrollView.contentOffset.x * sizeMultiplier, y:self.editScrollView.contentOffset.y * sizeMultiplier)
            
            let images = self.editImage?.cutoutSlides(cropSquare: self.cropSquare, scale: self.editScrollView.zoomScale, offset: scaledOffset)
            
            cropPreviewViewController.image1 = images?.left
            cropPreviewViewController.image2 = images?.right
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateEditImageViewConstraints()
        
        self.updateCropView()
        self.animateLayout()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.editImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.updateEditImageViewConstraints()
        
        self.updateCropView()
        self.view.layoutIfNeeded()
        
        self.dismiss(animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.editImageView
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
        self.selectPhoto()
    }
    
    @IBAction private func flipPhoto(_ sender:UIButton){
        self.editImage = self.editImage?.flipHorizontal()
    }
    
    @IBAction private func rotatePhoto(_ sender:UIButton){
        self.editImage = self.editImage?.rotate()
        self.updateEditImageViewConstraints()
        
        self.updateCropView()
        self.view.layoutIfNeeded()
    }
    
    @IBAction private func cropVertical(_ sender:UIButton){
        self.cropSquare = false
        
        self.cropVerticalButton.isSelected = true
        self.cropSquareButton.isSelected = false
        
        self.updateCropView()
        self.animateLayout()
    }
    
    @IBAction private func cropSquare(_ sender:UIButton){
        self.cropSquare = true
        
        self.cropVerticalButton.isSelected = false
        self.cropSquareButton.isSelected = true
        
        self.updateCropView()
        self.animateLayout()
    }
    
    @IBAction private func previewCrop(_ sender:UIButton){
        if self.editImage != nil{
            self.performSegue(withIdentifier: ImageCropSegueIdentifier.showPreview.rawValue, sender: sender)
        }
    }
    
    // MARK: - Private
    
    private func animateLayout(){
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateCropView(){
        if self.cropSquare{
            self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.width / 2.0
        }
        else{
            self.cropViewHeightConstraint.constant = self.editParentView.bounds.size.width / (16.0 / 9.0)
        }
    }
    
    private func updateEditImageViewConstraints(){
        self.updateAspectConstraint()
        self.updateConstantConstraint()
    }
    
    private func updateAspectConstraint(){
        guard let editImage = self.editImage else{
            return
        }
        
        if let realAspectContraint = self.editImageViewAspectConstraint{
            self.editImageView.removeConstraint(realAspectContraint)
        }
        
        let aspect = editImage.size.height / editImage.size.width
        
        let aspectConstraint = NSLayoutConstraint(item: self.editImageView, attribute: .height, relatedBy: .equal, toItem: self.editImageView, attribute: .width, multiplier: aspect, constant: 0.0)
        self.editImageView.addConstraint(aspectConstraint)
        
        self.editImageViewAspectConstraint = aspectConstraint
    }
    
    private func updateConstantConstraint(){
        guard let editImage = self.editImage else{
            return
        }
        
        if let realConstantConstraint = self.editImageViewConstantConstraint{
            self.editParentView.removeConstraint(realConstantConstraint)
        }
        
        let aspect = editImage.size.height / editImage.size.width
        let scaledHeight = self.editParentView.bounds.size.width * aspect
        
        let constantConstraint:NSLayoutConstraint
        
        if scaledHeight > self.editParentView.bounds.size.height{
            constantConstraint = NSLayoutConstraint(item: self.editImageView, attribute: .width, relatedBy: .equal, toItem: self.editParentView, attribute: .width, multiplier: 1.0, constant: 0.0)
        }
        else{
            constantConstraint = NSLayoutConstraint(item: self.editImageView, attribute: .height, relatedBy: .equal, toItem: self.editParentView, attribute: .height, multiplier: 1.0, constant: 0.0)
        }
        
        self.editParentView.addConstraint(constantConstraint)
        self.editImageViewConstantConstraint = constantConstraint
    }
}
