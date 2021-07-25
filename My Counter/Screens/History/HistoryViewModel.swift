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
    @Published var historyList: [CountHistory] = [] {
        didSet {
            objectWillChange.send()
            self.selections = [Bool](repeating: false, count: historyList.count)
        }
    }
    @Published var selections: [Bool] = []
    @Published var isRefresh = false
    @Published var isFirstLoad = true
    @Published var total = 0
    @Published var isCounting = false
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
            let history = historyList[first]
            AppDelegate.shared().showProgressHUD()

            firebaseManager.removeHistory(countHistory: history) { (error) in
                if error == nil {
                    self.historyList.remove(atOffsets: offset)
                    self.objectWillChange.send()
                }
                else {
                    AppDelegate.shared().showCommonAlertError(error!)
                }
                AppDelegate.shared().dismissProgressHUD()
            }
        }
        
    }
    
    func countTotal() {
        total = 0
        for index in 0..<historyList.count {
            if selections[index] {
                total += historyList[index].count
            }
        }
    }

}
