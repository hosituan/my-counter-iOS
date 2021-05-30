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
    
    func drawEclipseOnImage(boxes: [Box], showConfident: Bool = false) -> UIImage? {
        
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        self.draw(at: CGPoint.zero)
        var count = 1
        for box in boxes {
            let rect = CGRect(x: box.x, y: box.y , width: box.width, height: box.height)
            let textSize: CGFloat = CGFloat(box.width / 5)
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(5.0)
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.addEllipse(in: rect)
            context?.strokePath()
            let countText: NSString = "\(count)" as NSString
            countText.draw(at: CGPoint(x: rect.midX - textSize / 2, y: rect.midY - textSize / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.red])
            if showConfident {
                let scoreText: NSString = "\(box.score)" as NSString
                scoreText.draw(at: CGPoint(x: rect.midX - textSize / 2 - 4, y: rect.midY + textSize / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize - 4, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            count += 1
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
