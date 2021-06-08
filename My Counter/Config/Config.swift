//
//  Config.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import Foundation
import UIKit
import ObjectiveC
import Firebase

//let storageUrl = "gs://my-counter-c02e5.appspot.com"
//let templateChild = "Template"
//let historyChild = "History"
//let proposeChild = "Propose"
//let idLength = 5

var apiUrl = "http://34.71.32.225" //default

struct CountRequest {
    static let upload = apiUrl + "/upload"
    static let count = apiUrl + "/count"
    static let prepare = apiUrl + "/prepare"
    static let add = apiUrl + "/add"
}
