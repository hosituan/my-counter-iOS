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
    
    var tempImage: UIImage?
    @Published var resultImage: UIImage?
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
            resultImage = nil
            boxResponse = nil
        }
    }
    @Published var spentTime = 0
    @Published var countTime = 0
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var isAdvanced = true {
        didSet {
            resultImage = nil
            boxResponse = nil
        }
    }
    @Published var showConfidence: Bool = false {
        didSet {
            
        }
    }
    @Published var date: String = Date.getCurrentDate(withTime: true)
    @Published var rating: Int = 0 {
        didSet {
            FirebaseManager().updateHistory(rate: rating, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
        }
    }
    
    @Published var boxResponse: BoxResponse? {
        didSet {
            if let boxResponse = boxResponse, let selectedImage = selectedImage {
                resultImage = selectedImage
                let boxes = boxResponse.result
                self.rating = 0
                date = Date.getCurrentDate(withTime: true)
                var rects = [CGRect]()
                for box in boxes {
                    let rect = CGRect(x: box.x, y: box.y , width: box.width, height: box.height)
                    rects.append(rect)
                }
                resultImage = resultImage?.drawEclipseOnImage(rects: rects)
                FirebaseManager().uploadHistory(boxResponse, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
            }
        }
    }
    
    func start() {
        if boxResponse == nil && selectedImage != nil {
            startCount()
        }
        else {
            saveImage()
        }
    }
    
    func saveImage() {
        if let selectedImage = resultImage {
            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
                AppDelegate.shared().showSuccess()
            }
        }
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
            AppDelegate.shared().api?.count(image: img, template: template, advanced: isAdvanced) { (result, error) in
                AppDelegate.shared().api?.socket?.disconnect()
                AppDelegate.shared().dismissProgressHUD()
                self.countTimeCounter?.invalidate()
                self.spentTimeCounter?.invalidate()
                if error == nil {
                    self.boxResponse = result
                }
                else {
                    self.error = error
                    self.showAlert = true
                }
            }
            
        }
    }
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
