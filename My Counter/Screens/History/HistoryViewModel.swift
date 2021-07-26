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
    @Published var itemWasSelected = false
    @Published var total = 0 {
        didSet {
            if total == 0 {
                self.itemWasSelected = false
            }
            else {
                self.itemWasSelected = true
            }
        }
    }
    
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
    
    func createCSV() {
        let date = Date.getCurrentDate(withTime: true)
        let sFileName = "MYCOUNTER_\(date).csv"
        let docDicPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let docURL = URL(fileURLWithPath: docDicPath).appendingPathComponent(sFileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        csvWriter?.writeField("DATE")
        csvWriter?.writeField("IMAGE_URL")
        csvWriter?.writeField("TEMPLATE_NAME")
        csvWriter?.writeField("COUNT")
        csvWriter?.writeField("RATE")
        csvWriter?.finishLine()

        for index in 0..<historyList.count {
            if selections[index] {
                csvWriter?.writeField(historyList[index].date)
                csvWriter?.writeField(historyList[index].url)
                csvWriter?.writeField(historyList[index].name)
                csvWriter?.writeField(historyList[index].count)
                csvWriter?.writeField(historyList[index].rate)
                csvWriter?.finishLine()

            }
        }
        csvWriter?.writeField("Total:")
        csvWriter?.writeField("")
        csvWriter?.writeField("")
        csvWriter?.writeField("\(total)")
        csvWriter?.writeField("")
        csvWriter?.finishLine()


        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        do {
            try buffer.write(to: docURL)
        }
        catch {
            AppDelegate.shared().showCommonAlert(message: "Can't Create CSV File")
            return
        }
        AppDelegate.shared().showCommonAlert(message: "Create CSV File Successfully as \(sFileName)")
        self.isCounting = false
        self.total = 0
        self.selections = [Bool](repeating: false, count: self.historyList.count)
    }

}
