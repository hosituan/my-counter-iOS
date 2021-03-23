//
//  HomeViewModel.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    @Published var templateList: [Template] = [Template(image: UIImage(named: "egg-icon")!, name: "Chicken Egg", description: "Count eggs"),
                                                Template(image: UIImage(named: "egg-icon")!, name: "Egg", description: "Count eggs"),
                                                Template(image: UIImage(named: "egg-icon")!, name: "Egg", description: "Count eggs"),
                                                Template(image: UIImage(named: "egg-icon")!, name: "Egg", description: "Count eggs"),
                                                Template(image: UIImage(named: "egg-icon")!, name: "Egg", description: "Count eggs"),
    ]
}
