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
    @State var showActionSheet = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("My Counter")
                    .bold()
                    .font(.system(size: 20))
                if userLogin.isLogin {
                    ProfileMenuView(user: userLogin.user)
                    Divider()
                }
                else {
                    Button(action: {
                        showLoginAction()
                    }) {
                        RectangleButton(title: Strings.LoginTitle, backgroundColor: Color.Count.PrimaryColor, textColor: .white)
                            .frame(height: 56)
                            .padding(.vertical)
                    }
                }
                
                
                Spacer()
                Divider()
                Button(action: {
                    showActionSheet = true
                }) {
                    Text(Strings.LogoutTitle)
                        .foregroundColor(Color.Count.RedColor)
                        .font(.system(size: 16, weight: .bold, design: .default))
                }
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: UIScreen.main.bounds.height - 100,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
            .padding()
        }.actionSheet(isPresented: $showActionSheet) {
            sheet
        }
        
    }
    var sheet: ActionSheet {
        ActionSheet(
            title: Text(Strings.LougoutConfirmTitle),
            buttons: [
                .destructive(Text(Strings.LogoutTitle), action: {
                    userLogin.logout()
                }),
                .cancel(Text(Strings.CancelTitle), action: {
                })
            ])
    }
}


