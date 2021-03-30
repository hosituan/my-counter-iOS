//
//  TextSize14.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct TextSize14Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.Count.PrimaryTextColor)
            .font(.system(size: 14, weight: .bold, design: .default))
            
    }
}

struct NavigationLink_14: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.Count.NavigationLinkColor)
            .font(.system(size: 14, weight: .medium, design: .default))
            
    }
}
