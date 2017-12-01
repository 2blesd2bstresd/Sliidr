//
//  UIImage+CutoutSlides.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/29/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

extension UIImage{
    func cutoutSlides(cropRect:CGRect) -> (left:UIImage, right:UIImage)?{
        let leftBounds:CGRect = CGRect(origin: cropRect.origin, size: CGSize(width: cropRect.size.width / 2.0, height: cropRect.size.height))
        let rightBounds:CGRect = CGRect(origin: CGPoint(x:cropRect.midX, y:cropRect.origin.y), size: CGSize(width: cropRect.size.width / 2.0, height: cropRect.size.height))
        
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
            let cutoutImage = UIImage(cgImage:realCutoutCGImage)
        
            UIGraphicsBeginImageContextWithOptions(rect.size, true, self.scale)
        
            let origin = CGPoint(x:-CGFloat.minimum(0.0, rect.origin.x), y:-CGFloat.minimum(0.0, rect.origin.y))
            
            cutoutImage.draw(in: CGRect(origin:origin, size:cutoutImage.size))
            
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return croppedImage
        }
        
        return nil
    }
}
