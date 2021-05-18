//
//  TextSize16.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import SwiftUI

struct TextSize16Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.Count.PrimaryColor)
            .font(.system(size: 16, weight: .bold, design: .default))
            
    }
}

struct NavigationLink_16: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.Count.NavigationLinkColor)
            .font(.system(size: 16, weight: .medium, design: .default))
    }
}
