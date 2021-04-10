//
//  TextInputAutoHeight.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import SwiftUI

struct TextInputAutoHeight: View {
    @Binding var text: String
    @State var isTextFocus: Bool = false
    @State var textHeight: CGFloat = 14
    var placeHolder: String = ""
    var scroll: Any?
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .fill(Color.clear)
                .frame(height: textHeight + 24)
            UITextInputWrapper(text: $text, calculatedHeight: $textHeight, isFocus: $isTextFocus, placeHolder: placeHolder)
                .border(Color(hex: "#e7e9ef"), width: 1)
                .frame(minHeight: textHeight, maxHeight: textHeight)
                .padding(.bottom, 16)
        }
    }
}
