//
//  View+Hidden.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}


extension View {
    public func asUIImage() -> UIImage {
           let controller = UIHostingController(rootView: self)
           controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
           UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
           let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
           controller.view.bounds = CGRect(origin: .zero, size: size)
           controller.view.sizeToFit()
           let image = controller.view.asUIImage()
           controller.view.removeFromSuperview()
           return image
       }
    
}
