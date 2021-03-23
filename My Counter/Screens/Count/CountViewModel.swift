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
    @Published var countRespone: CountRespone?
    @Published var sourceType: UIImagePickerController.SourceType = .camera
}
