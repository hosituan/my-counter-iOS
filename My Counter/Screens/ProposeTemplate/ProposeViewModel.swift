//
//  ProposeViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/05/2021.
//

import Foundation
import SwiftUI
import Combine
import TLPhotoPicker
import Photos

class ProposeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var selectedAsset: [TLPHAsset] = [TLPHAsset]() {
        didSet {
            selectedImages.removeAll()
            for asset in selectedAsset {
                if let image = asset.fullResolutionImage {
                    selectedImages.append(Image(uiImage: image))
                }
            }
        }
    }
    @Published var selectedImages: [Image] = []
    
    func sendRequest() {
        FirebaseManager().proposeTemplate(name: name, description: description, images: selectedAsset) { error in
            if error == nil {
                AppDelegate.shared().showCommonAlertError(error)
            }
            else {
                AppDelegate.shared().showCommonAlert(message: "Request Successful. We will check and release it soon!")
            }
        }
    }
}
