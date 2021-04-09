//
//  Config.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import UIKit
import ObjectiveC

let apiUrl = "http://34.71.32.225"
let storageUrl = "gs://my-counter-c02e5.appspot.com"
let templateChild = "Template"
let idLength = 5


enum Request: String {
    case upload = "/upload"
    case count = "/count"
}
