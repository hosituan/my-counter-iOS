//
//  RegisterView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userLogin: UserLogin
    @State var isResetActive : Bool = false
    @ObservedObject var loginViewModel = LoginViewModel()
    @State var isShowLogin = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    Text("This is logo")
                        .foregroundColor(Color.Count.PrimaryColor)
                        .bold()
                        .padding(.vertical)
                    VStack(alignment: .leading, spacing: 0) {
                        MainTextField(title: Strings.EN.EmailFieldName, placeHolder: Strings.EN.EmailPlaceHolder, value: $loginViewModel.email)
                            .padding(.bottom, 23)
                        SecureTextField(value: $loginViewModel.password, title: Strings.EN.PasswordFieldName)
                        SecureTextField(value: $loginViewModel.confirmPassword, title: Strings.EN.RepeatPasswordFieldName)
                    }
                    .padding(.bottom, 24)
                    Button(action: {
                        userLogin.signUp(email: loginViewModel.email, password: loginViewModel.password)
                    }, label: {
                        ZStack {
                            Rectangle()
                                .fill(loginViewModel.confirm ? Color.Count.PrimaryColor : Color.Count.ContentGrayTextColor )
                                .frame(height: 56)
                            Text(Strings.EN.RegisterTitle)
                                .foregroundColor(.white)
                                .bold()
                        }
                    }).disabled(!loginViewModel.confirm)
                    .padding(.bottom)
                }

            }
            .listSeparatorStyle(.none)
            .padding(.horizontal, 16)
            .navigationBarTitle(Text(Strings.EN.RegisterTitle))
            .navigationBarItems(leading: Button(action: {
            }, label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(.black)
                
            }))
            
        }
        
    }
}
