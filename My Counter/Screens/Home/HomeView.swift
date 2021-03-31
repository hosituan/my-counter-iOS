//
//  HomeView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import SwiftUI
import ASCollectionView_SwiftUI
import QGrid

struct HomeView: View {
    var showMenuAction: (() -> Void)
    @ObservedObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var menuHandler: MenuHandler
    func content() -> some View {
        VStack {
            if #available(iOS 14.0, *) {
                ScrollView {
                    LazyVStack {
                        Section {
                            Text("Select Template")
                                .bold()
                                .padding()
                        }
                        TemplateCollectionView(templateList: homeViewModel.templateList)
                    }.background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                List {
                    VStack {
                        Section {
                            Text("Select Template")
                                .bold()
                                .padding()
                        }
                        TemplateCollectionView(templateList: homeViewModel.templateList)
                    }
                }.background(Color.clear)
                .buttonStyle(PlainButtonStyle())
            }
        }
        
    }
    var body: some View {
        NavigationView {
            content()
                .padding()
                .background(navigationLinkList)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitle("My Counter", displayMode: .large)
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
                    UITableView.appearance().separatorStyle = .none
                    homeViewModel.loadTemplate()
                }
            
        }.accentColor(Color.Count.PrimaryColor)
        
    }
    
    var navigationLinkList: some View {
        VStack {
            NavigationLink(
                destination: AddTemplateView(),
                isActive: $menuHandler.isShowAddTemplate,
                label: {})
            NavigationLink(destination: TemplateListView(), isActive: $menuHandler.isShowTemplateList) {}
        }.isHidden(true)
    }
}




//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct HideRowSeparatorModifier: ViewModifier {
    static let defaultListRowHeight: CGFloat = 44
    var insets: EdgeInsets
    var background: Color
    
    init(insets: EdgeInsets, background: Color) {
        self.insets = insets
        var alpha: CGFloat = 0
        if #available(iOS 14.0, *) {
            UIColor(background).getWhite(nil, alpha: &alpha)
        } else {
            // Fallback on earlier versions
        }
        assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .padding(insets)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: Self.defaultListRowHeight,
                alignment: .leading
            )
            .listRowInsets(EdgeInsets())
            .background(background)
    }
}

extension EdgeInsets {
    static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}

extension View {
    func hideRowSeparator(insets: EdgeInsets = .defaultListRowInsets, background: Color = .white) -> some View {
        modifier(HideRowSeparatorModifier(insets: insets, background: background))
    }
}
