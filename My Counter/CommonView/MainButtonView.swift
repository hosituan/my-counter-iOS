//
//  MainButtonView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct MainButtonView: View {
    var title = Strings.DefaultButtonTitle
    var backgroundColor = Color.blue
    var textColor = Color.white
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(height: 56)
                .cornerRadius(8)
            Text(title)
                .foregroundColor(textColor)
                .bold()
        }
    }
}
