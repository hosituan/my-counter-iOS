//
//  SecureTextFiled.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct SecureTextField: View {
    @Binding var value: String
    var title: String
    var subTitle: String?
    @State var isHide: Bool  = true
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if isHide {
                MainTextField(title: title, subTitle: subTitle, placeHolder: "", isSecure: true, value: $value)
            }
            else {
                MainTextField(title: title, subTitle: subTitle, placeHolder: "", value: $value)
            }
            
            Button(action: {
                isHide = !isHide
            }, label: {
                Image(isHide ? "eye_hidden" : "eye_show")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                    
                    
            })
        }.onDisappear() {
            isHide = true
        }

    }

}


struct SecureSignUpTextField_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextField(value: .constant(""),title: "Example", subTitle: "??")
    }
}
