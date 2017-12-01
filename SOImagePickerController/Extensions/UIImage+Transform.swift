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
    
    //https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    func orientedUp() -> UIImage?{
        guard let cgImage = self.cgImage else{
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y:0.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0.0, y:self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2.0)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        default:
            break
        }
        
        guard let colorSpace = cgImage.colorSpace else{
            return self
        }
        
        guard let context = CGContext(data:nil,
                                      width:Int(self.size.width),
                                      height:Int(self.size.height),
                                      bitsPerComponent:cgImage.bitsPerComponent,
                                      bytesPerRow:0,
                                      space:colorSpace,
                                      bitmapInfo:cgImage.bitmapInfo.rawValue) else{
                                    return self
        }
        
        context.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width:self.size.height, height:self.size.width)))
        default:
            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size))
        }
        
        guard let newCGImage = context.makeImage() else{
            return self
        }
        
        return UIImage(cgImage: newCGImage)
    }
}
