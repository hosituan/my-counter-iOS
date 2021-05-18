//
//  HomeView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI
import ASCollectionView_SwiftUI
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
                    .listRowBackground(Color.clear)
                TemplateCollectionView(templateList: homeViewModel.templateList, selection: $homeViewModel.selection, didTap: $homeViewModel.isShowCount)
                    .listRowBackground(Color.clear)
            }
            .pullToRefresh(isShowing: $homeViewModel.isShowingRefresh, onRefresh: {
                homeViewModel.loadTemplate()
            })
            
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
                        .foregroundColor(Color.Count.PrimaryColor)
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .padding(.leading)
                        .padding(.trailing, 4)
                }
            })
            .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .listSeparatorStyle(.none)
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
        ZStack {
            VStack {
                NavigationLink(
                    destination: AddTemplateView(),
                    isActive: $menuHandler.isShowAddTemplate,
                    label: {})
                NavigationLink(destination: TemplateListView(templates: homeViewModel.templateList), isActive: $menuHandler.isShowTemplateList) {}
                NavigationLink(destination: CountView(template: homeViewModel.selected), isActive: $homeViewModel.isShowCount) {}
                NavigationLink(destination: HistoryView(), isActive: $menuHandler.isShowHistory) {}
                NavigationLink(destination: ProfileView(), isActive: $menuHandler.isTapAvatar) {}
            }
            .background(Color.red)
        }

    }
}




//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

