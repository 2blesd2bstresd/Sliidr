//
//  UIImage+Flip.swift
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
}
