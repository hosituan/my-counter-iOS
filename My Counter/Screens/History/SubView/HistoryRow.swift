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
    @State var item: CountHistory
    var body: some View {
        VStack {
            HStack {
                if let urlString = item.url, let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 90, alignment: .center)
                        .cornerRadius(2)
                        .clipped()
                }
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .modifier(TextSize14Bold())
                    Text("Result: \(item.count)")
                        .bold()
                        .font(.system(size: 14))
                    Text(item.date)
                        .font(.system(size: 12))
                        .italic()
                    RatingView(rating: $item.rate, date: item.date)
                }.padding([.leading, .top])
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 32)
        }.buttonStyle(PlainButtonStyle())
    }
}

