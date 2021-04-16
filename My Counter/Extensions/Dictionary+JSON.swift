//
//  Dictionary+JSON.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

import Foundation
extension Dictionary {
    var jsonStringRepresentation: Data? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                              options: [.prettyPrinted]) else {
            return nil
        }
        
        return theJSONData
    }
}
