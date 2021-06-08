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
    var template: Template
    var image: Image?
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
            else {
                image?
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.Count.PrimaryTextColor)
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(color: .primary, radius: 2)
                    .frame(width: 64, height: 64, alignment: .center)
                    .padding([.top], 7)
            }
            Text(template.name ?? "")
                .bold()
                .fixedSize(horizontal: true, vertical: true)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(template.description ?? "")
                .italic()
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Spacer()
        }
        
        .frame(maxHeight: UIScreen.main.bounds.height / 2, alignment: .center)
        .buttonStyle(PlainButtonStyle())
        
        
    }
}
