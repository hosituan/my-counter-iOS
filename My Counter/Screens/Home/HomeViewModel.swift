//
//  HomeViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    //let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    let firebaseManager = FirebaseManager()
    @Published var templateList: [Template] = [Template]()
    @Published var isFirstLoad = true
    @Published var selected: Template = Template() {
        didSet {
            AppDelegate.shared().api?.prepare(id: selected.id ?? "", completionHandler: { (res) in
                print(res)
            })
        }
    }
    @Published var isShowCount: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var isShowingRefresh = false
    func loadTemplate() {
        if isFirstLoad {
            AppDelegate.shared().showProgressHUD()
        }
        firebaseManager.loadTemplate { (result) in
            self.templateList = result
            self.objectWillChange.send()
            self.isShowingRefresh = false
            if self.isFirstLoad {
                AppDelegate.shared().dismissProgressHUD()
                self.isFirstLoad = false
            }
        }
    }
    init() {
        loadTemplate()
    }
}
