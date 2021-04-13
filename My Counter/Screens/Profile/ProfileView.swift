//
//  ProfileView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 13/04/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel = ProfileViewModel()
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                InfoView()
                Spacer()
            }
        }.navigationBarTitle(Text(profileViewModel.user?.displayName ?? Strings.EN.ProfileTitle))
    }
}

struct InfoView: View {
    var body: some View {
        HStack {
            VStack {
                let user = AppDelegate.shared().currenUser
                if let url = user?.photoURL {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(50)
                }
                else {
                    Image("person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(50)
                }
                Text("role")
                    .italic()
                    .modifier(TextSize12Medium())
            }
            .padding()
            Spacer()
        }
    }
}
