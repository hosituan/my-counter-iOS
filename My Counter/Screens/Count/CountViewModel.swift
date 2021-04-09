//
//  CountViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit
import ProgressHUD
import SDWebImage

class CountViewModel: ObservableObject {
    init(template: TemplateServer) {
        self.template = template
    }
    var template: TemplateServer
    let api = API()
    @Published var selectedImage: UIImage?
    @Published var spentTime = 0
    @Published var countTime = 0
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
    
    func start() {
        if selectedImage == nil {
            saveImage()
        }
        else {
            startCount()
        }
    }
    
    func saveImage() {
        guard let url = URL(string: countRespone?.url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                ProgressHUD.colorHUD = .clear
                ProgressHUD.showSucceed()
            }
        }.resume()
        
    }
    
    func startCount() {
        spentTime = 0
        self.countTime = 0
        if let img = selectedImage {
            let spentTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                ProgressHUD.show(Strings.EN.Uploading + " (\(self.spentTime)s).")
                self.spentTime += 1
            }
            api.uploadImage(image: img, template: template) { (result, error) in
                if error == nil {
                    spentTime.invalidate()
                    let countTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        ProgressHUD.show(Strings.EN.Counting + " (\(self.countTime)s).")
                        self.countTime += 1
                    }
                    self.api.requestCount(imageName: result?.fileName ?? "" , template: self.template) { (result, error) in
                        self.countRespone = result
                        countTime.invalidate()
                        ProgressHUD.dismiss()
                        self.spentTime += self.countTime
                    }
                }
                else {
                    spentTime.invalidate()
                    ProgressHUD.dismiss()
                }
            }
        }
    }
}

enum CountMethod: String {
    case defaultMethod = "1"
    case advanced = "2"
    case other = ""
}
