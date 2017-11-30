//
//  UIImage+Transform.swift
//  SOImagePickerController
//
//  Created by Lucas Best on 11/29/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit

extension UIImage{
    func flipHorizontal() -> UIImage?{
        guard let realCGImage = self.cgImage else{
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: -1.0, y: -1.0)
        context?.translateBy(x: -self.size.width, y: -self.size.height)

        context?.draw(realCGImage, in:CGRect(origin: CGPoint.zero, size: self.size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
    
    func rotate() -> UIImage?{
        guard let realCGImage = self.cgImage else{
            return nil
        }

        let rotatedRect = CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width)
        
        UIGraphicsBeginImageContextWithOptions(rotatedRect.size, false, self.scale)
        let center = CGPoint(x:rotatedRect.midX, y:rotatedRect.midY)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: center.x, y: center.y)
        context?.rotate(by: CGFloat.pi / -2.0)
        context?.scaleBy(x: 1.0, y: -1.0)

        context?.draw(realCGImage, in:CGRect(origin: CGPoint(x: -self.size.width / 2.0, y:-self.size.height / 2.0), size: self.size))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}
