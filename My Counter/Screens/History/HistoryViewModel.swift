//
//  HistoryViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import SwiftUI
class HistoryViewModel: ObservableObject {
    let firebaseManager = FirebaseManager()
    @Published var historyList: [CountHistory] = []
    @Published var isRefresh = false
    @Published var isFirstLoad = true
    init() {
        loadHistory()
    }
    func loadHistory() {
        if isFirstLoad {
            AppDelegate.shared().showProgressHUD()
        }
        firebaseManager.loadHistory { (result, error) in
            if self.isFirstLoad {
                self.isFirstLoad = false
                AppDelegate.shared().dismissProgressHUD()
            }
            if error == nil, var result = result {
                result.sort {
                    $0.date > $1.date
                }
                self.historyList = result
                self.objectWillChange.send()
            }
            else {
                AppDelegate.shared().showCommonAlertError(error)
            }
        }
    }
}
