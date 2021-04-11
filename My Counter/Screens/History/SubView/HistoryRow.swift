//
//  HistoryRow.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
struct HistoryRow: View {
    var item: CountHistory
    var body: some View {
        VStack {
            HStack {
                if let urlString = item.url, let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(2)
                        .clipped()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(item.name)
                        .modifier(TextSize14Bold())
                    Text("Result: \(item.count)")
                        .bold()
                        .font(.system(size: 14))
                    Text(item.date)
                        .foregroundColor(Color.Count.ContentGrayTextColor)
                        .font(.system(size: 12))
                        .italic()
                }
            }
            Divider()
        }.buttonStyle(PlainButtonStyle())
    }
}

