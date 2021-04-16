//
//  BoxResponse.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

import Foundation

struct BoxResponse: BaseResponse {
    var success: Bool
    var message: String
    var name: String
    var fileName: String
    var result: [Box]
}

struct Box: Decodable {
    var x: Int
    var y: Int
    var radius: Int
    var score: Double
}
