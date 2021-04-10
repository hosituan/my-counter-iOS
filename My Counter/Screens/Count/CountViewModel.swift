//
//  CountViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit
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
    @Published var countRespone: CountResponse? {
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
                AppDelegate.shared().showSuccess()
            }
        }.resume()
        
    }
    
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert {
                AppDelegate.shared().showCommonAlertError(self.error)
            }
        }
    }
    @Published var error: CountError?
    
    func startCount() {
        spentTime = 0
        self.countTime = 0
        if let img = selectedImage {
            
            AppDelegate.shared().showProgressHUD()
            let spentTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.spentTime += 1
                AppDelegate.shared().updateHUD(text: Strings.EN.Uploading, value: self.spentTime)
                    
            }
            api.uploadImage(image: img, template: template) { (result, error) in
                if error == nil {
                    spentTime.invalidate()
                    let countTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.countTime += 1
                        AppDelegate.shared().updateHUD(text: Strings.EN.Counting, value: self.countTime)
                    }
                    self.api.requestCount(imageName: result?.fileName ?? "" , template: self.template) { (result, error) in
                        if error == nil {
                            self.countRespone = result
                        }
                        else {
                            self.error = error
                            self.showAlert = true
                        }
                        countTime.invalidate()
                        AppDelegate.shared().dismissProgressHUD()
                        self.spentTime += self.countTime
                    }
                }
                else {
                    spentTime.invalidate()
                    AppDelegate.shared().dismissProgressHUD()
                    self.error = error
                    self.showAlert = true
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
