//
//  HomeViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit
import ProgressHUD

class HomeViewModel: ObservableObject {
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    let firebaseManager = FirebaseManager()
    @Published var templateList: [TemplateServer] = [TemplateServer]()
    
    func loadTemplate() {
        ProgressHUD.show()
        firebaseManager.loadTemplate { (result) in
            self.templateList = result
            self.objectWillChange.send()
            ProgressHUD.dismiss()
        }
    }
}
