//
//  AddTemplateViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import Combine
import SwiftUI

class AddTemplateViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var driveID: String = ""
    @Published var selectedImage: UIImage?
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    let firebase = FirebaseManager()
    func addTemplate() {
        if let image = selectedImage, name != "", driveID != "" {
            let id = randomString(length: idLength)
            AppDelegate.shared().showAlertWithTwoButton(message: name + Strings.EN.VerifyMessageAdd) { [self] _ in
                let template = Template(id: id, name: name, description: description, driveID: driveID)
                AppDelegate.shared().showProgressHUD()
                firebase.uploadTemplate(template: template, image: image) { (error) in
                    AppDelegate.shared().dismissProgressHUD()
                    if error == nil {
                        self.alertTitle = Strings.EN.DoneTitle
                        self.alertMessage = Strings.EN.TemplateAdded
                    }
                    else {
                        self.alertTitle = Strings.EN.ErrorTitle
                        self.alertMessage = Strings.EN.ErrorMessage
                    }
                    self.showAlert = true
                }
                
                AppDelegate.shared().api?.add(id: id, name: name, driveID: driveID)
            }
        }
        else {
            self.alertTitle = Strings.EN.ErrorTitle
            self.alertMessage = Strings.EN.WrongInput
            AppDelegate.shared().showCommonAlert(message: Strings.EN.WrongField)
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
