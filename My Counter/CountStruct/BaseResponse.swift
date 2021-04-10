//
//  Response.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 10/04/2021.
//

import Foundation
protocol BaseResponse: Decodable {
    var success: Bool { get set }
    var message: String { get set }
}
