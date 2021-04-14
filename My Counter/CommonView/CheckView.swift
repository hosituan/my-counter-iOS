//
//  CheckView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/03/2021.
//

import Foundation
import SwiftUI

struct CheckView: View {
    @Binding var isChecked:Bool
    var title:String
    func toggle(){isChecked = !isChecked}
    var body: some View {
        Button(action: toggle){
            HStack (alignment: .top) {
                Image(systemName: isChecked ? "checkmark.square": "square")
                    .foregroundColor(Color.Count.PrimaryColor)
                Text(title)
                    .font(.system(size: 14))
                    .italic()
                    .foregroundColor(Color.Count.PrimaryColor)
            }

        }

    }

}
