//
//  TemplateRow.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct TemplateRow: View {
    var teamplate: Template
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(teamplate.name ?? "")
                        .modifier(TextSize14Bold())
                    Text(teamplate.description ?? "")
                        .foregroundColor(Color.Count.ContentGrayTextColor)
                        .font(.system(size: 12))
                        .italic()
                }
                Spacer()
                if let urlString = teamplate.imageUrl, let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(50)
                        .padding()
                }
            }
        }
    }
}


