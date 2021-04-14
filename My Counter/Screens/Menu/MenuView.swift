//
//  MenuView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var menuHandler: MenuHandler
    @EnvironmentObject var userLogin: UserLogin
    var showLoginAction: (() -> Void)
    
    
    var logoutView: some View {
        VStack {
            Divider()
            Button(action: {
                userLogin.logout()
            }) {
                Text(Strings.EN.LogoutTitle)
                    .foregroundColor(Color.Count.RedColor)
                    .font(.system(size: 16, weight: .bold, design: .default))
            }
        }
    }
    
    var adminActionView: some View {
        VStack {
            MenuActionRowView(title: Strings.EN.AddTemplateNavTitle)
                .onTapGesture {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        sd.hideMenu()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            menuHandler.isShowAddTemplate = true
                        })
                    }
                }
            Divider()
            MenuActionRowView(title: Strings.EN.TemplateListNavTitle)
                .onTapGesture {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        sd.hideMenu()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            menuHandler.isShowTemplateList = true
                        })
                    }
                }
            Divider()
        }
    }
    
    var normalUserActionView: some View {
        VStack {
            MenuActionRowView(title: Strings.EN.HistoryNavTitle)
                .onTapGesture {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        sd.hideMenu()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            menuHandler.isShowHistory = true
                        })
                    }
                }
            Divider()
        }
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("My Counter")
                    .bold()
                    .font(.system(size: 20))
                if let user = userLogin.user, userLogin.isLogin {
                    ProfileMenuView(user: user)
                    Rectangle()
                        .fill(Color(hex: "#ecf0f1"))
                        .frame(height: 4)
                        .cornerRadius(2)
                        .padding(.horizontal, 24)
                        .padding(.bottom)
                }
                else {
                    Button(action: {
                        showLoginAction()
                    }) {
                        RectangleButton(title: Strings.EN.LoginTitle, backgroundColor: Color.Count.PrimaryColor, textColor: .white)
                            .frame(height: 56)
                            .padding(.vertical)
                    }
                }
                if userLogin.isLogin {
                    adminActionView
                }
                normalUserActionView
                    //.isHidden(!userLogin.isLogin)
                Spacer()
                logoutView
                    .isHidden(!userLogin.isLogin)
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: UIScreen.main.bounds.height - 100,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
            .padding()
        }
        
    }
}



