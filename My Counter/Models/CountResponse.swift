//
//  CountResponse.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation

struct CountRespone: Decodable {
    var count: Int
    var url: String
    var fileName: String
}

struct CommonRespone: Decodable {
    var success: Bool
    var message: String
}


struct UploadRespone: Decodable {
    var success: Bool
    var message: String
    var fileName: String
}
