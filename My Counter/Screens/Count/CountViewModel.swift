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
import SwiftUI
import UIImageColors

class CountViewModel: ObservableObject {
    init(template: TemplateServer) {
        self.template = template
    }
    var template: TemplateServer
    @Published var selectedImage: UIImage? {
        didSet {
            selectedImage?.getColors { color in
                if let primaryColor = color?.primary, let secondaryColor = color?.secondary, let backgroundColor = color?.background {
                    Color.Count.BackgroundColor = Color(backgroundColor)
                    Color.Count.PrimaryColor = Color(primaryColor)
                    Color.Count.PrimaryTextColor = Color(secondaryColor)
                    
                    self.objectWillChange.send()
                }

            }
            
            countResponse = nil
        }
    }
    @Published var spentTime = 0
    @Published var countTime = 0
    @Published var countResponse: CountResponse? {
        didSet {
            if let safeRespone = countResponse {
                self.rating = 0
                date = Date.getCurrentDate(withTime: true)
                FirebaseManager().uploadHistory(safeRespone, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
            }
        }
    }
    
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var isDefault: Bool = true {
        didSet {
            method = isDefault ? .defaultMethod : .advanced
        }
    }
    @Published var isAdvanced = true {
        didSet {
            countResponse = nil
        }
    }
    @Published var showConfidence: Bool = false
    @Published var method: CountMethod = .defaultMethod
    @Published var date: String = Date.getCurrentDate(withTime: true)
    @Published var rating: Int = 0 {
        didSet {
            FirebaseManager().updateHistory(rate: rating, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
        }
    }
    
    @Published var boxResult: [Box]? {
        didSet {
            if let boxes = boxResult {
                selectedImage = selectedImage?.circle(diameter: 50)
//                for box in boxes{
//
//                }
            }

        }
    }
    

    func start() {
        if countResponse == nil && selectedImage != nil {
            startCount()
        }
        else {
            saveImage()
        }
    }
    
    func saveImage() {
        guard let url = URL(string: countResponse?.url ?? "") else { return }
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
    
    func subscribeCountResult() {
        AppDelegate.shared().api?.socket?.connect()
        AppDelegate.shared().api?.socket!.on("countResult") { data, ack in
            guard let dataInfo = data.first as? [String: Any], let json = dataInfo.jsonStringRepresentation  else { return }
            do {
                let result = try JSONDecoder().decode(CommonResponse.self, from: json)
                if result.success, result.message == "Start counting", !self.startCounting {
                    self.startCounting = true
                }
            }
            catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    var countTimeCounter: Timer?
    var spentTimeCounter: Timer?
    @Published var startCounting = false {
        didSet {
            if startCounting {
                spentTimeCounter?.invalidate()
                countTimeCounter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.countTime += 1
                    self.spentTime += 1
                    AppDelegate.shared().updateHUD(text: Strings.EN.Counting, value: self.countTime)
                }
            }
        }
    }
    
    func startCount() {
        self.startCounting = false
        self.spentTime = 0
        self.countTime = 0
        if let img = selectedImage {
            AppDelegate.shared().showProgressHUD()
            subscribeCountResult()
            spentTimeCounter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.spentTime += 1
                AppDelegate.shared().updateHUD(text: Strings.EN.Uploading, value: self.spentTime)
            }
            if true {
                AppDelegate.shared().api?.requestBoxCount(image: selectedImage!, template: template, advanced: isAdvanced) { (result, error) in
                    AppDelegate.shared().api?.socket?.disconnect()
                    AppDelegate.shared().dismissProgressHUD()
                    self.countTimeCounter?.invalidate()
                    self.spentTimeCounter?.invalidate()
                    if error == nil {
                        self.boxResult = result?.result
                    }
                    else {
                        self.error = error
                        self.showAlert = true
                    }
                }
            }
            else {
                AppDelegate.shared().api?.count(image: img, template: template, advanced: isAdvanced, showConfidence: showConfidence) { (res, error) in
                    AppDelegate.shared().api?.socket?.disconnect()
                    AppDelegate.shared().dismissProgressHUD()
                    self.countTimeCounter?.invalidate()
                    self.spentTimeCounter?.invalidate()
                    if error == nil {
                        self.countResponse = res
                    }
                    else {
                        self.error = error
                        self.showAlert = true
                    }
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


extension UIImage {
    func circle(diameter: CGFloat, color: UIColor = .green) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)

        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return img
    }
}
