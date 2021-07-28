//
//  LoginView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var userLogin: UserLogin
    var dismissAction: (() -> Void)
    @State var isResetActive : Bool = false
    @ObservedObject var loginViewModel = LoginViewModel()
    @State var isHidePassword = true
//    @State var isShowReset = false
//    @State var isShowRegister = false
    @State var tabIndex = 0
    
        
    
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
            
            Button(action: {
                userLogin.logInGoogle()
            }) {
                Image("google_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.horizontal, 3)
            }.onReceive(userLogin.objectWillChange) { _ in
                if userLogin.isLogin {
                    dismissAction()
                }
            }
            Image("apple_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.horizontal, 3)
        }
    }
    var loginView: some View {
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    MainTextField(title: Strings.EN.EmailFieldName, placeHolder: Strings.EN.EmailPlaceHolder, value: $loginViewModel.email)
                        .padding(.bottom, 23)
                    SecureTextField(value: $loginViewModel.password, title: Strings.EN.PasswordFieldName)
                }
                .padding(.bottom, 24)
                Button(action: {
                    self.loginAction()
                    userLogin.signIn(email: loginViewModel.email, password: loginViewModel.password)
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
                .onReceive(loginViewModel.objectWillChange) { _ in
                    if userLogin.isLogin {
                        dismissAction()
                    }
                }
                bottomView
                }
        .padding(.horizontal, 16)

    }
    
    var registerView: some View {
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    MainTextField(title: Strings.EN.EmailFieldName, placeHolder: Strings.EN.EmailPlaceHolder, value: $loginViewModel.email)
                        .padding(.bottom, 23)
                    SecureTextField(value: $loginViewModel.password, title: Strings.EN.PasswordFieldName)
                        .padding(.bottom, 23)
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
                .onReceive(loginViewModel.objectWillChange) { _ in
                    if userLogin.isLogin {
                        dismissAction()
                    }
                }
            }
        .listSeparatorStyle(.none)
        .padding(.horizontal, 16)
    }
    var body: some View {
            VStack(spacing:30) {
                HStack {
                    Button(action: {
                        self.dismissAction()
                    }, label: {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24, alignment: .center)
                                .foregroundColor(.black)
                    })
                    .padding()
                    Spacer()
                }
                Spacer()
                Image("countLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180, alignment: .center)
                CustomTopTabBar(tabIndex: $tabIndex)
                    if tabIndex == 0 {
                       loginView
                    }
                    else {
                       registerView
                    }
                Spacer()
            }
            .onAppear {
                loginViewModel.clearData()
            }
            .padding(.bottom)
            .modifier(DismissingKeyboard())

    }
    
    func loginAction() {
        let email = loginViewModel.email.trimmingCharacters(in: .whitespaces).lowercased()
        let password = loginViewModel.password.trimmingCharacters(in: .whitespaces)        
    }
    
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            TabBarButton(text: "Login", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0)
                }
            Spacer()
            TabBarButton(text: "Register", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Spacer()
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.system(size: 26))
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .black)
        Spacer()

    }
}


struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}





