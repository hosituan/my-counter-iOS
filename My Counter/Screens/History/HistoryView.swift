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
    @State private var selections: [String] = []
    @State private var isCounting = false
    @State private var total = 0


    var body: some View {
        List(selection: $selection) {
            ForEach(historyViewModel.historyList.indices, id: \.self) { index in
                HistoryRow(item: historyViewModel.historyList[index],isSelected: false)
                    .onTapGesture {
                        if (!isCounting) {
                            viewControllerHolder.value?.present(style: .fullScreen) {
                                ZStack(alignment: .top) {
                                    PreviewViewImage(link: historyViewModel.historyList[index].url, text: "\(Strings.EN.CountResultTitle)\(historyViewModel.historyList[index].name): \(historyViewModel.historyList[index].count)")
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                            
                        } else {
                            if (!selections.contains(historyViewModel.historyList[index].date)) {
                                selections.append(historyViewModel.historyList[index].date)
                                total += historyViewModel.historyList[index].count
                            }
                            else {
                                selections.removeAll(where: { $0 == historyViewModel.historyList[index].date  })
                                total -= historyViewModel.historyList[index].count
                            }
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
                self.total = 0
                self.selections = []
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
        .navigationBarTitle(isCounting ? "Total: \(total)" : Strings.EN.HistoryNavTitle )
    }
}


