//
//  TextSize12.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct TextSize12Regular: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.foregroundColor(Color(UIColor(hexString: "898989")))
            .font(.system(size: 12, weight: .regular, design: .default))
            
    }
}

struct TextSize12Medium: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.foregroundColor(Color(UIColor.Drone.ContentTextColor))
            .font(.system(size: 12, weight: .medium, design: .default))
            
    }
}

struct TextSize12Regular_Color: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.foregroundColor(Color(UIColor.Drone.ContentTextColor))
            .font(.system(size: 12, weight: .regular, design: .default))
    }
}


struct TextSize12Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.foregroundColor(Color(UIColor.Drone.ContentTextColor))
            .font(.system(size: 12, weight: .bold, design: .default))
            
    }
}
