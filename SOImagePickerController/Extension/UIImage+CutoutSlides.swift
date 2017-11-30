//
//  UIImage+CutoutSlides.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/29/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

extension UIImage{
    func cutoutSlides(cropSquare:Bool, scale:CGFloat = 1.0, offset:CGPoint = CGPoint.zero) -> (left:UIImage, right:UIImage)?{
        let leftBounds:CGRect
        
        let zoomReciprocal = 1.0 / scale
        
        let cropRect = CGRect(origin:offset, size:CGSize(width:self.size.width * zoomReciprocal, height:self.size.height * zoomReciprocal))
        
        let halfedSize = CGSize(width: cropRect.size.width / 2.0, height: cropRect.size.height)
        
        if cropSquare{
            let height = cropRect.size.width / 2.0
            let difference = cropRect.size.height - height
            
            leftBounds = CGRect(origin: CGPoint(x:cropRect.origin.x, y:cropRect.origin.y + difference / 2.0), size:halfedSize)
        }
        else{
            leftBounds = CGRect(origin: cropRect.origin, size: halfedSize)
        }
        
        let rightBounds:CGRect
        
        if cropSquare{
            let height = cropRect.size.width / 2.0
            let difference = cropRect.size.height - height
            
            rightBounds = CGRect(origin: CGPoint(x:cropRect.midX, y:cropRect.origin.y + difference / 2.0), size:halfedSize)
        }
        else{
            rightBounds = CGRect(origin: CGPoint(x:cropRect.midX, y:cropRect.origin.y), size:halfedSize)
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
