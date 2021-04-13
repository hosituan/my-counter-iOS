//
//  ProfileViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 13/04/2021.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user = AppDelegate.shared().currenUser
}
