//
//  CountViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit

class CountViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var countRespone: CountRespone? {
        didSet {
            tempImage = selectedImage
            selectedImage = countRespone != nil ? nil : selectedImage
        }
    }
    @Published var tempImage: UIImage?
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var isDefault: Bool = true {
        didSet {
            method = isDefault ? .defaultMethod : .advanced
        }
    }
    @Published var method: CountMethod = .defaultMethod
}

enum CountMethod: String {
    case defaultMethod = "1"
    case advanced = "2"
    case other = ""
}
