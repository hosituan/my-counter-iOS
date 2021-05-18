//
//  MainButtonView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct MainButtonView: View {
    var title = Strings.EN.DefaultButtonTitle
    var backgroundColor = Color.Count.PrimaryColor
    var textColor = Color.Count.PrimaryTextColor
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
