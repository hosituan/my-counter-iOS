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
import SnapKit

struct PreviewViewImage: UIViewControllerRepresentable {
    var link: String?
    var images: [UIImage]?
    var text: String = ""
    var index = 0
    func makeUIViewController(context: Context) -> some LightboxController {
        var lightboxImages: [LightboxImage] = []
        if let link = link, let url = URL(string: link) {
            lightboxImages = [LightboxImage(imageURL: url) ]
        }
        else if let images = images {
            for image in images {
                lightboxImages.append(LightboxImage(image: image))
            }
        }
        else {
            return LightboxController()
        }
        
        let controller = LightboxController(images: lightboxImages, startIndex: index)
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.CloseButton.image = UIImage(systemName: "xmark")
        LightboxConfig.CloseButton.image?.withTintColor(.red)
        
        LightboxConfig.PageIndicator.enabled = false
        controller.modalPresentationStyle = .fullScreen
        controller.dynamicBackground = true
        let textLabel = UILabel().then {
            $0.text = text
            $0.font = .systemFont(ofSize: 14, weight: .bold)
            $0.textColor = Color.Count.PrimaryTextColor.uiColor()
        }
        controller.view.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

