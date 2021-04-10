//
//  HomeView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI
import ASCollectionView_SwiftUI
import QGrid
import SwiftUIListSeparator
import SwiftUIRefresh

struct HomeView: View {
    var showMenuAction: (() -> Void)
    @ObservedObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var menuHandler: MenuHandler
    var body: some View {
        NavigationView {
            List {
                Text("Select template")
                    .bold()
                    .padding()
                TemplateCollectionView(templateList: homeViewModel.templateList, selection: $homeViewModel.selection, didTap: $homeViewModel.isShowCount)
            }
            .pullToRefresh(isShowing: $homeViewModel.isShowingRefresh, onRefresh: {
                homeViewModel.loadTemplate()
            })
            .listSeparatorStyle(.none)
            .background(navigationLinkList)
            .edgesIgnoringSafeArea(.bottom)
            .listStyle(PlainListStyle())
            .navigationBarTitle("My Counter", displayMode: iOS14 ? .large : .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showMenuAction()
            }) {
                ZStack(alignment: .topTrailing) {
                    Image("nav-menu")
                        .renderingMode(.template)
                        .foregroundColor(Color.Count.PrimaryTextColor)
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .padding(.leading)
                        .padding(.trailing, 4)
                }
            })
            .onAppear() {
                UITableView.appearance().tableFooterView = UIView()
                UITableView.appearance().separatorStyle = .none
            }
            
        }
        .buttonStyle(PlainButtonStyle())
        .edgesIgnoringSafeArea(.bottom)
        .accentColor(Color.Count.PrimaryColor)
        
    }
    
    var navigationLinkList: some View {
        VStack {
            NavigationLink(
                destination: AddTemplateView(),
                isActive: $menuHandler.isShowAddTemplate,
                label: {})
            NavigationLink(destination: TemplateListView(templates: homeViewModel.templateList), isActive: $menuHandler.isShowTemplateList) {}
            NavigationLink(destination: CountView(template: homeViewModel.selected), isActive: $homeViewModel.isShowCount) {}
        }.opacity(0)
    }
}




//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

