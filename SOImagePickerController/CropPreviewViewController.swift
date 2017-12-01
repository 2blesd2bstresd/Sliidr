//
//  CropPreviewViewController.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/29/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

protocol CropPreviewViewControllerDelegate : class{
    func cropPreviewViewControllerCancel(_ cropPreviewViewController:CropPreviewViewController)
    func cropPreviewViewControllerComplete(_ cropPreviewViewController:CropPreviewViewController)
}

class CropPreviewViewController: UIViewController, UIBarPositioningDelegate {
    
    @IBOutlet private var scrollView:UIScrollView!
    
    @IBOutlet private var imageView1:UIImageView!
    @IBOutlet private var imageView2:UIImageView!
    
    var image1:UIImage!
    var image2:UIImage!
    
    weak var delegate:CropPreviewViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView1.image = self.image1
        self.imageView2.image = self.image2
        
        let aspect = self.image1.size.height / self.image2.size.width
        
        let aspectConstraint1 = NSLayoutConstraint(item: self.imageView1, attribute: .height, relatedBy: .equal, toItem: self.imageView1, attribute: .width, multiplier: aspect, constant: 0.0)
        self.imageView1.addConstraint(aspectConstraint1)
       
        let aspectConstraint2 = NSLayoutConstraint(item: self.imageView2, attribute: .height, relatedBy: .equal, toItem: self.imageView2, attribute: .width, multiplier: aspect, constant: 0.0)
        
        self.imageView2.addConstraint(aspectConstraint2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIBarPositioningDelegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    // MARK: - Actions
    
    @IBAction private func cancel(_ sender:UIBarButtonItem){
        self.delegate?.cropPreviewViewControllerCancel(self)
    }
    
    @IBAction private func save(_ sender:UIBarButtonItem){
        UIImageWriteToSavedPhotosAlbum(self.image1, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(self.image2, nil, nil, nil)
        
        self.delegate?.cropPreviewViewControllerComplete(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
