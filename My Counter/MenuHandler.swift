//
//  MenuHandler.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

class MenuHandler: ObservableObject {
    var dismissAction: (() -> Void) = {}
    @Published var isShowSearch = false
    @Published var isTapAvatar = false 
    @Published var isTapNotification = false
    @Published var isShowAddTemplate = false
    @Published var isShowTemplateList = false
    @Published var isShowHistory = false
    @Published var isShowPropose = false
    
    @Published var numberOfNoti = 0
    @Published var didUpdateTemplate: Bool = false

}
