//
//  ProfileMenuView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI

struct ProfileMenuView: View {
    var body: some View {
        HStack {
            Image("default_avatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 64, height: 64, alignment: .center)
                .cornerRadius(32)
            VStack(alignment: .leading) {
                Text("Hồ Sĩ Tuấn")
                    .bold()
                    .font(.system(size: 14))
                Text("iOS Developer")
                    .italic()
                    .font(.system(size: 12))
            }
            Spacer()
            Image("noti_icon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(12)
                .frame(width: 24, height: 24, alignment: .center)
        }
        
    }
}

struct ProfileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuView()
    }
}
