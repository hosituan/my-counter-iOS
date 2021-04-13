//
//  ProfileMenuView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth
struct ProfileMenuView: View {
    var user: User?
    @EnvironmentObject var menuHandler: MenuHandler
    var body: some View {
        HStack {
            Button(action: {
                let scene = UIApplication.shared.connectedScenes.first
                if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.hideMenu()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        menuHandler.isTapAvatar = true
                    })
                }
                
            })
            {
                if let url = user?.photoURL {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64, alignment: .center)
                        .cornerRadius(32)
                }
                else {
                    Image("default_avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64, alignment: .center)
                        .cornerRadius(32)
                }
                VStack(alignment: .leading) {
                    Text(user?.displayName ?? "")
                        .bold()
                        .font(.system(size: 14))
                    Text(user?.email ?? "")
                        .italic()
                        .font(.system(size: 12))
                }
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Image("noti_icon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(12)
                .frame(width: 24, height: 24, alignment: .center)
        }
    }

}

//struct ProfileMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileMenuView()
//    }
//}
