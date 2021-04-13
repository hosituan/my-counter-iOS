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
    
    func deleteHistory(at offset: IndexSet) {
        if let first = offset.first {
            AppDelegate.shared().showProgressHUD()
            let history = historyList[first]
            self.historyList.remove(at: first)
            firebaseManager.removeHistory(countHistory: history) { (error) in
                if error == nil {
                    
                }
                else {
                    AppDelegate.shared().showCommonAlertError(error!)
                }
                AppDelegate.shared().dismissProgressHUD()
            }
        }
    }

}
