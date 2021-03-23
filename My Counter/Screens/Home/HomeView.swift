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
    
    func content() -> some View {
        VStack {
            Section {
                Text("Select Template")
                    .bold()
                    .padding()
            }
            TemplateCollectionView(templateList: homeViewModel.templateList)
        }
    }
    var body: some View {
        NavigationView {
            Form {
                List {
                    content()
                }.background(Color.clear)
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("My Counter", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showMenuAction()
            }) {
                ZStack(alignment: .topTrailing) {
                    Image("nav-menu")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .padding(.leading)
                        .padding(.trailing, 4)
                }
            })
            .onAppear() {
                UITableView.appearance().separatorStyle = .none
            }
            
        }
    }
}




//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
