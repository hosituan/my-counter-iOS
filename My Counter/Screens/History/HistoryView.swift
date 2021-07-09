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
    @State private var selection = Set<String>()
    @State private var isCounting = false


    var body: some View {
        List(selection: $selection) {
            ForEach(historyViewModel.historyList.indices, id: \.self) { index in
                HistoryRow(item: historyViewModel.historyList[index])
                    .onTapGesture {
                        if (!isCounting){
                            viewControllerHolder.value?.present(style: .fullScreen) {
                                ZStack(alignment: .top) {
                                    PreviewViewImage(link: historyViewModel.historyList[index].url, text: "\(Strings.EN.CountResultTitle)\(historyViewModel.historyList[index].name): \(historyViewModel.historyList[index].count)")
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                            
                        } else {
                            
                        }
                    }
                    .listRowBackground(Color.clear)
            }
            .onDelete(perform: historyViewModel.deleteHistory(at:))
            

        }
        .environment(\.editMode, .constant(self.isCounting ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
        .toolbar(content: {
            Button(action: {
                self.isCounting.toggle()
            }, label: {
                Text(isCounting ? "Done" : "Count")
                                    .frame(width: 80, height: 40)
            })
        })
        .listSeparatorStyle(.none)
        .onAppear() {
            historyViewModel.loadHistory()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarTitle(Strings.EN.HistoryNavTitle)
    }
}


