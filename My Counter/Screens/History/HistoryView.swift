//
//  HistoryView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 11/04/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import SwiftUIListSeparator

struct HistoryView: View {
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @ObservedObject var historyViewModel = HistoryViewModel()
    var body: some View {
        List {
            ForEach(historyViewModel.historyList.indices, id: \.self) { index in
                HistoryRow(item: historyViewModel.historyList[index])
                    .onTapGesture {
                        viewControllerHolder.value?.present(style: .fullScreen) {
                            ZStack(alignment: .top) {
                                PreviewViewImage(link: historyViewModel.historyList[index].url, text: "\(Strings.EN.CountResultTitle)\(historyViewModel.historyList[index].name): \(historyViewModel.historyList[index].count)")
                                    .edgesIgnoringSafeArea(.all)
                            }
                            
                        }
                    }
                    .listRowBackground(Color.clear)
            }.onDelete(perform: historyViewModel.deleteHistory(at:))
            
        }
        .listSeparatorStyle(.none)
        .onAppear() {
            historyViewModel.loadHistory()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarTitle(Strings.EN.HistoryNavTitle)
    }
}


