//
//  PreviewImage.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import UIKit
import SwiftUI
import Lightbox

struct PreviewViewImage: UIViewControllerRepresentable {
    
    var link: String?
    func makeUIViewController(context: Context) -> some LightboxController {
        guard let link = link, let url = URL(string: link) else { return LightboxController() }
        let images = [LightboxImage(imageURL: url) ]
        let controller = LightboxController(images: images)
        controller.modalPresentationStyle = .fullScreen
        controller.dynamicBackground = false
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
}
