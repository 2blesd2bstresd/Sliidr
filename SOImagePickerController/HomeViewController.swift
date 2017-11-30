//
//  HomeViewController.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/30/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

enum HomeSegueIdentifier : String{
    case cropPhoto
}

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoSelector {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifierString = segue.identifier, let segueIdentifier = HomeSegueIdentifier(rawValue:segueIdentifierString) else{
            super.prepare(for: segue, sender: sender)
            return
        }
        
        switch segueIdentifier {
        case .cropPhoto:
            let imageCropViewController = segue.destination as! ImageCropViewController
            imageCropViewController.editImage = sender as? UIImage
        }
    }

    // MARK: - Actions

    @IBAction private func selectPhoto(_ sender:UIButton){
        self.selectPhoto()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.performSegue(withIdentifier: HomeSegueIdentifier.cropPhoto.rawValue, sender: info[UIImagePickerControllerOriginalImage])
        self.dismiss(animated: true)
    }
}
