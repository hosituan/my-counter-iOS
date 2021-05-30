//
//  TemplateListViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import Combine
import SwiftUI


class TemplateViewModel: ObservableObject {
    let firebaseManager = FirebaseManager()
    @Published var templates: [Template] = [Template]()
    @Published var isShowingRefresh = false
    func loadTemplate() {
        firebaseManager.loadTemplate { (result) in
            self.templates = result
            self.isShowingRefresh = false
        }
    }
    
    func deleteTemplate(at offset: IndexSet) {
        if let first = offset.first {
            AppDelegate.shared().showProgressHUD()
            firebaseManager.removeTemplate(template: templates[first]) { (error) in
                if error == nil {
                    self.templates.remove(at: first)
                }
                else {
                    AppDelegate.shared().showCommonAlertError(error!)
                }
                AppDelegate.shared().dismissProgressHUD()
            }
        }
    }
}
