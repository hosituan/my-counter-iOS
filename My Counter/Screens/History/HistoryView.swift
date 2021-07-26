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
        VStack {
            List {
                ForEach(historyViewModel.historyList.indices, id: \.self) { index in
                    HistoryRow(item: historyViewModel.historyList[index], isSelected: $historyViewModel.selections[index])
                        .onTapGesture {
                            if (!self.historyViewModel.isCounting) {
                                viewControllerHolder.value?.present(style: .fullScreen) {
                                    ZStack(alignment: .top) {
                                        PreviewViewImage(link: historyViewModel.historyList[index].url, text: "\(Strings.EN.CountResultTitle)\(historyViewModel.historyList[index].name): \(historyViewModel.historyList[index].count)")
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                            } else {
                                self.historyViewModel.selections[index].toggle()
                                self.historyViewModel.countTotal()
                            }
                        }
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: historyViewModel.deleteHistory(at:))
                

            }
            .toolbar(content: {
                Button(action: {
                    self.historyViewModel.isCounting.toggle()
                    self.historyViewModel.total = 0
                    self.historyViewModel.selections = [Bool](repeating: false, count: historyViewModel.historyList.count)
                }, label: {
                    Text(historyViewModel.isCounting ? "Done" : "Count")
                                        .frame(width: 80, height: 40)
                })
            })
            .listSeparatorStyle(.none)
            .onAppear() {
                historyViewModel.loadHistory()
            }
            .navigationBarTitle(historyViewModel.isCounting ? "Total: \(historyViewModel.total)" : Strings.EN.HistoryNavTitle)
            if(historyViewModel.itemWasSelected) {
                Button(action: {
                    historyViewModel.createCSV()
                }, label: {
                    MainButtonView(title:"Create CSV")
                })
                .opacity(historyViewModel.itemWasSelected ? 1 : 0)
                .disabled(!historyViewModel.itemWasSelected)
                .padding()
                .background(Color.clear)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))

        
    }
}


