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

extension Date {
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func getSpecificTime(_ type: Calendar.Component) -> Int {
        return Calendar.current.component(type, from: self)
    }
    
}

extension String {
    func toDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: self)
    }
}

