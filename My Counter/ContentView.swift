//
//  ContentView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 22/03/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Alamofire
import ProgressHUD

struct ContentView: View {
    var showMenuAction: (() -> Void)
    @State var isActive:Bool = false
    var body: some View {
        VStack {
            if self.isActive {
                HomeView(showMenuAction: showMenuAction)
                    
            } else {
                LaunchView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
