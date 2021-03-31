//
//  MenuActionRowView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import SwiftUI
struct MenuActionRowView: View {
    var title: String = ""
    var body: some View {
        HStack {
            Text(title)
                .modifier(TextSize16Bold())
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.Count.PrimaryColor)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20, alignment: .center)
        }
        .padding(6)
    }
}
