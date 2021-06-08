//
//  UIView+Extension.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/05/2021.
//

import Foundation
import UIKit

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
