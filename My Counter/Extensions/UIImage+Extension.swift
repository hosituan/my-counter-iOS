//
//  UIImage+Resize.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import UIKit
extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func drawEclipseOnImage(rects: [CGRect]) -> UIImage? {
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        self.draw(at: CGPoint.zero)
        for rect in rects {
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(5.0)
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.addEllipse(in: rect)
            context?.strokePath()
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func drawRectangleOnImage(rects: [CGRect]) -> UIImage? {
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        self.draw(at: CGPoint.zero)
        for rect in rects {
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(5.0)
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.addRect(rect)
            context?.strokePath()
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
