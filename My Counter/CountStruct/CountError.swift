//
//  CountError.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 10/04/2021.
//

import Foundation
public struct CountError: Error {
    init(_ error: Error? = nil, reason: String? = nil) {
        self.reason = error?.localizedDescription ?? ""
        if reason != nil {
            self.reason = reason ?? ""
        }
    }
    var reason: String = ""
}
