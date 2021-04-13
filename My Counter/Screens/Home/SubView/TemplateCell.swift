//
//  TemplateCell.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct TemplateCell: View {
    var template: TemplateServer
    var body: some View {
        VStack {
            if let urlStr = template.imageUrl, let url = URL(string: urlStr) {
                WebImage(url: url)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(color: .primary, radius: 2)
                    .padding([.top], 7)
            }
            Text(template.name ?? "")
                .bold()
                .font(.system(size: 14))
                .lineLimit(1)
            Text(template.description ?? "")
                .italic()
                .font(.system(size: 12))
                .lineLimit(1)
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
        
    }
}
