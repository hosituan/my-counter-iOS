//
//  MenuView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("My Counter")
                    .bold()
                    .font(.system(size: 20))
                ProfileMenuView()
                Divider()
                Spacer()
            }
            .padding()
        }
    }
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
