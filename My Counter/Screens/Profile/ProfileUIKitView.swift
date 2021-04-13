//
//  ProfileUIKitView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 13/04/2021.
//

import Foundation
import MXParallaxHeader
import SwiftUI

struct ProfileUIKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let headerView = UIImageView()
        headerView.image = UIImage(named: "egg-icon")
        headerView.contentMode = .scaleAspectFit
        let scrollView = UIScrollView()
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 150
        scrollView.parallaxHeader.mode = .fill
        scrollView.parallaxHeader.minimumHeight = 20
        
        let inforView = UIHostingController(rootView: InfoView())
        scrollView.addSubview(inforView.view)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
