//
//  Date+Extentiosn.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation

extension Date {
    static func getCurrentDate(withTime: Bool = false) -> String {
        let formatter  = DateFormatter()
        formatter.dateStyle = .short
        if withTime {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return formatter.string(from: Date())
    }
}
