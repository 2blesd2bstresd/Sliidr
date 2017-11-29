//
//  UIImage+CutoutSlides.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/29/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

extension UIImage{
    func cutoutSlides(cropSquare:Bool) -> (left:UIImage, right:UIImage)?{
        let leftBounds:CGRect
        
        let halfedSize = CGSize(width: self.size.width / 2.0, height: self.size.height)
        
        if cropSquare{
            let height = self.size.width / 2.0
            let difference = self.size.height - height
            
            leftBounds = CGRect(origin: CGPoint(x:0, y:difference / 2.0), size:halfedSize)
        }
        else{
            leftBounds = CGRect(origin: CGPoint.zero, size: halfedSize)
        }
        
        let rightBounds:CGRect
        
        if cropSquare{
            let height = self.size.width / 2.0
            let difference = self.size.height - height
            
            rightBounds = CGRect(origin: CGPoint(x:self.size.width / 2.0, y:difference / 2.0), size:halfedSize)
        }
        else{
            rightBounds = CGRect(origin: CGPoint(x:self.size.width / 2.0, y:0.0), size:halfedSize)
        }
        
        if let realLeftImage = self.cutout(rect: leftBounds), let realRightImage = self.cutout(rect: rightBounds){
            return (left:realLeftImage, right:realRightImage)
        }
        else{
            return nil
        }
    }
    
    // MARK: - Private
    
    private func cutout(rect:CGRect) -> UIImage?{
        guard let realCGImage = self.cgImage else{
            return nil
        }
        
        let cutoutCGImage = realCGImage.cropping(to: rect)
        
        if let realCutoutCGImage = cutoutCGImage{
            return UIImage(cgImage:realCutoutCGImage)
        }
        
        return nil
    }
}
