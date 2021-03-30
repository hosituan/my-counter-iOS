//
//  LaunchView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Text("Splash Screen")
                .bold()
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(Color.Count.PrimaryColor)
//            Image(["launch1","launch2","launch3","launch4","launch5","launch6",].randomElement()!)
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//            Image("splash_logo")
//                .resizable()
//                .frame(width: 94, height: 94)
        }
    }
}

