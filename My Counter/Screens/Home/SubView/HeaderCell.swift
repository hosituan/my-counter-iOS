//
//  HeaderCell.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/05/2021.
//

import Foundation
import SwiftUI

struct HeaderCell: View {
    let title: String
    let color: Color
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(title)
                    .bold()
                    .padding(.horizontal, 16)
                Spacer()
            }
            Spacer()
        }
        .padding(0).background(color.opacity(0.7))
    }
}
