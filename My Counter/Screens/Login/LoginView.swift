//
//  LoginView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI
import UIKit
import ProgressHUD

struct LoginView: View {
    @EnvironmentObject var userLogin: UserLogin
    var dismissAction: (() -> Void)
    @State var isResetActive : Bool = false
    @ObservedObject var loginViewModel = LoginViewModel()
    @State var isHidePassword = true
    
    @State var isShowReset = false
    @State var isShowRegister = false
    
    var bottomView: some View {
        HStack {
            Button(action: {
                userLogin.logInFacebook()
            }) {
                Image("facebook_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.horizontal, 3)
            }.onReceive(userLogin.objectWillChange) { _ in
                if userLogin.isLogin {
                    dismissAction()
                }
            }
            
            Image("google_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.horizontal, 3)
            Image("apple_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.horizontal, 3)
        }
    }
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    //                    Image("Logo")
                    //                        .padding(32)
                    Text("This is logo")
                        .foregroundColor(Color.Count.PrimaryColor)
                        .bold()
                        .padding(.vertical)
                    VStack(alignment: .leading, spacing: 0) {
                        MainTextField(title: Strings.EN.EmailFieldName, placeHolder: Strings.EN.EmailPlaceHolder, value: $loginViewModel.email)
                            .padding(.bottom, 23)
                        SecureTextField(value: $loginViewModel.password, title: Strings.EN.PasswordFieldName)
                    }
                    .padding(.bottom, 24)
                    Button(action: {
                        self.loginAction()
                    }, label: {
                        ZStack {
                            Rectangle()
                                .fill(loginViewModel.validate ? Color.Count.PrimaryColor : Color.Count.ContentGrayTextColor )
                                .frame(height: 56)
                            Text(Strings.EN.LoginTitle)
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                    }).disabled(!loginViewModel.validate)
                    .padding(.bottom)
                    
                    NavigationLink(destination: ResetPasswordView(), isActive: $isShowReset) {
                        HStack {
                            Text(Strings.EN.ResetPasswordTitle)
                                .foregroundColor(Color.Count.NavigationLinkColor)
                                .modifier(NavigationLink_14())
                            Spacer()
                        }
                    }
                    
                    NavigationLink(destination: RegisterView(), isActive: $isShowRegister) {
                        HStack {
                            Text(Strings.EN.RegisterTitle)
                                .foregroundColor(Color.Count.NavigationLinkColor)
                                .modifier(NavigationLink_14())
                            Spacer()
                        }
                    }.padding(.bottom)
                    
                    bottomView
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
                .navigationBarTitle(Text(Strings.EN.LoginTitle))
                .navigationBarItems(leading: Button(action: {
                    self.dismissAction()
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
    
    func loginAction() {
        let email = loginViewModel.email.trimmingCharacters(in: .whitespaces).lowercased()
        let password = loginViewModel.password.trimmingCharacters(in: .whitespaces)        
    }
    
}




