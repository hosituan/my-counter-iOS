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
