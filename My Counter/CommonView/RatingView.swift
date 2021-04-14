//
//  RatingView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 13/04/2021.
//

import Foundation
import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var date: String?
    var max: Int = 5
    var body: some View {
        HStack {
            ForEach(1..<(max + 1), id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        self.rating = index
                        if let date = date {
                            FirebaseManager().updateHistory(rate: self.rating, userID: AppDelegate.shared().currenUser?.uid ?? "guest", day: date)
                        }
                    }
            }
        }
    }
    
    private func starType(index: Int) -> String {
        return index <= self.rating ? "star.fill" : "star"
        
    }
}
