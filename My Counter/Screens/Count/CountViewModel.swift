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
import TLPhotoPicker

class CountViewModel: ObservableObject {
    init(template: Template) {
        self.template = template
    }
    var template: Template
    @Published var showActionSheet = false
    //MARK:-- MultiSelect
    @Published var selectedAsset: [TLPHAsset] = [TLPHAsset]() {
        didSet {
            if selectedAsset.count == 0 { return }
            selectedImage = nil
            resultImage = nil
            resultImages = nil
            selectedImages.removeAll()
            for asset in selectedAsset {
                if let image = asset.fullResolutionImage {
                    selectedImages.append(Image(uiImage: image))
                }
            }
        }
    }
    
    @Published var score = 0.95 {
        didSet {
            scoreStr = String(format:"%.2f", score)
            if let boxResponse = boxResponse, let selectedImage = selectedImage {
                resultImage = selectedImage
                resultImage = resultImage?.drawOnImage(boxes: boxResponse.result, showConfident: showConfidence, isEclipse: template.isCircle ?? true, score: score.roundToDecimal(2))
            }
        }
    }
    @Published var scoreStr = "0.95"
    @Published var selectedImages: [Image] = []
    @Published var resultImages: [Image]? = []
    
    
    //MARK:-- SingleSelect
    @Published var resultImage: UIImage?
    @Published var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else {
                return
            }
            selectedImages.removeAll()
            selectedAsset.removeAll()
            resultImages = nil
            selectedImage.getColors { color in
                if let primaryColor = color?.primary, let secondaryColor = color?.secondary, let backgroundColor = color?.background {
                    self.backgroundColor = Color(backgroundColor)
                    Color.Count.PrimaryColor = Color(primaryColor)
                    Color.Count.PrimaryTextColor = Color(secondaryColor)
                    self.objectWillChange.send()
                }
            }
            resultImage = nil
            boxResponse = nil
        }
    }
    
    @Published var boxResponse: BoxResponse? {
        didSet {
            if let boxResponse = boxResponse, let selectedImage = selectedImage {
                resultImage = selectedImage
                let boxes = boxResponse.result
                date = Date.getCurrentDate(withTime: true)
                self.rating = 0
                resultImage = resultImage?.drawOnImage(boxes: boxResponse.result, showConfident: showConfidence, isEclipse: template.isCircle ?? true, score: score.roundToDecimal(2))
                FirebaseManager().uploadHistory(resultImage, name: template.name, count: boxes.count, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
            }
        }
    }
    
    //MARK:-- Change Color
    @Published var backgroundColor = Color.Count.BackgroundColor
    var primaryColor = Color.Count.PrimaryColor
    var textColor = Color.Count.PrimaryTextColor
    
    //MARK:-- Complete
    @Published var showShareSheet = false
    @Published var date: String = Date.getCurrentDate(withTime: true)
    @Published var rating: Int = 0 {
        didSet {
            FirebaseManager().updateHistory(rate: rating, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
        }
    }
    
    //MARK:-- Count Function
    @Published var spentTime = 0
    @Published var countTime = 0
    @Published var showConfidence: Bool = false {
        didSet {
            if let boxResponse = boxResponse, let selectedImage = selectedImage {
                resultImage = selectedImage
                resultImage = resultImage?.drawOnImage(boxes: boxResponse.result, showConfident: showConfidence, isEclipse: template.isCircle ?? true, score: score.roundToDecimal(2))
            }
        }
    }
    

    
    func start() {
        if boxResponse == nil && selectedImage != nil {
            startCount()
        }
        else {
            showShareSheet = true
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
            AppDelegate.shared().api?.countInBackground(image: img, template: template, resultBlock: { (object, error) in
                
            })
            if img.size.width < 1000 || img.size.height < 1000 {
                selectedImage = img.resizeImage(targetSize: CGSize(width: 1000, height: 1000))
            }
            
            AppDelegate.shared().showProgressHUD()
            subscribeCountResult()
            spentTimeCounter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.spentTime += 1
                AppDelegate.shared().updateHUD(text: Strings.EN.Uploading, value: self.spentTime)
            }
            guard let selectedImage = selectedImage else {
                return
            }
            AppDelegate.shared().api?.count(image: selectedImage, template: template) { (result, error) in
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
