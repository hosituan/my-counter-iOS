//
//  CountResponse.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 10/04/2021.
//

import Foundation
struct CountResponse: BaseResponse {
    var success: Bool
    var message: String
    var url: String
    var fileName: String
    var count: Int
}
