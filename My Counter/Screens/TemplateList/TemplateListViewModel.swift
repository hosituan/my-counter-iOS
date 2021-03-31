//
//  TemplateListViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import Combine
import SwiftUI
import ProgressHUD

class TemplateViewModel: ObservableObject {
    let firebaseManager = FirebaseManager()
    @Published var templates: [TemplateServer] = [TemplateServer]()
    
    func loadTemplate() {
        ProgressHUD.show()
        firebaseManager.loadTemplate { (result) in
            self.templates = result
            ProgressHUD.dismiss()
        }
    }
}
