//
//  Double+Extension.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 08/06/2021.
//

import Foundation
extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
