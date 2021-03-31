//
//  RectangleButton.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct RectangleButton: View {
    var title = Strings.EN.DefaultButtonTitle
    var backgroundColor = Color.blue
    var textColor = Color.white
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            Text(title)
                .foregroundColor(textColor)
                .bold()
        }
    }
}
