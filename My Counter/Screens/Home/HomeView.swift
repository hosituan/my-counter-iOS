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
    var columns: [GridItem] = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 16,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    Section(header: HeaderCell(title: Strings.EN.SelectTemplate, color: .white)) {
                        ForEach(homeViewModel.templateList.indices, id: \.self) { index in
                            Button(action: {
                                
                            }) {
                                TemplateCell(template: homeViewModel.templateList[index])
                                    .buttonStyle(PlainButtonStyle())
                                    .onTapGesture {
                                        homeViewModel.selected = homeViewModel.templateList[index]
                                        homeViewModel.isShowCount = true
                                    }
                                
                            }
                        }
                    }
                    Section(header: HeaderCell(title: Strings.EN.ProposeNavTitle, color: .white)) {
                        TemplateCell(template: Template(name: "Propose Object", description: "Propose description"), image: Image(systemName: "plus.circle"))
                            .onTapGesture {
                                menuHandler.isShowPropose = true
                            }
                        
                    }
                }
            }
            .background(navigationLinkList)
            .edgesIgnoringSafeArea(.bottom)
            .listStyle(PlainListStyle())
            .navigationBarTitle("My Counter")
            .navigationBarItems(trailing: Button(action: {
                self.showMenuAction()
            }) {
                ZStack(alignment: .topTrailing) {
                    Image("nav-menu")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .padding(.leading)
                        .padding(.trailing, 4)
                }
            })
            .pullToRefresh(isShowing: $homeViewModel.isShowingRefresh, onRefresh: {
                homeViewModel.loadTemplate()
            })
            .listSeparatorStyle(.none)
            .padding(.top, 0.3)
        }
        .buttonStyle(PlainButtonStyle())
        .edgesIgnoringSafeArea(.bottom)
        .accentColor(Color.Count.PrimaryColor)
    }
    
    var navigationLinkList: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack {
                NavigationLink(
                    destination: AddTemplateView(),
                    isActive: $menuHandler.isShowAddTemplate,
                    label: {})
                NavigationLink(destination: TemplateListView(templates: homeViewModel.templateList), isActive: $menuHandler.isShowTemplateList) {}
                NavigationLink(destination: CountView(template: homeViewModel.selected), isActive: $homeViewModel.isShowCount) {}
                NavigationLink(destination: HistoryView(), isActive: $menuHandler.isShowHistory) {}
                NavigationLink(destination: ProfileView(), isActive: $menuHandler.isTapAvatar) {}
                NavigationLink(destination: ProposeView(), isActive: $menuHandler.isShowPropose) {}
            }
        }
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

