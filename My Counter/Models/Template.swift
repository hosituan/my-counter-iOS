//
//  Template.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI
struct Template: Identifiable {
    var id: String = ""
    var image: UIImage = UIImage()
    var name: String = ""
    var description = ""
}

struct TemplateServer: Codable {
    var id: String?
    var name: String?
    var desciption: String?
    var imageUrl: String?
}
