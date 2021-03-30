//
//  MainTextFiled.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct MainTextField: View {
    var title = ""
    var subTitle: String?
    var placeHolder = ""
    var isSecure = false
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .modifier(TextSize14Bold())
                .padding(.bottom, 3)
            if let sub = subTitle {
                Text(sub)
                    .foregroundColor(Color(UIColor(hexString: "59648f")))
                    .font(.system(size: 10, weight: .regular, design: .default))
            }
            
            ZStack {
                if isSecure {
                    SecureField(placeHolder, text: $value)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.leading, .trailing], 16)
                        .frame(height: 56)
                        .border(Color(UIColor(hexString: "e7e9ef")), width: 1)
                }
                else {
                    TextField(placeHolder, text: $value)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding([.leading, .trailing], 16)
                        .frame(height: 56)
                        .border(Color(UIColor(hexString: "e7e9ef")), width: 1)
                }
            }.padding(.top, 8)
        }
        
    }
}
