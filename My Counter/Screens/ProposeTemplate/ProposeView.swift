//
//  ProposeView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 30/05/2021.
//

import Foundation
import SwiftUI
import SwiftUIListSeparator

struct ProposeView: View {
    @ObservedObject var proposeViewModel = ProposeViewModel()
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                Text(Strings.EN.ProposeDescription)
                    .italic()
                    .modifier(TextSize16Bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                
                MainTextField(title: Strings.EN.Name + ":", placeHolder: Strings.EN.PlaceHolderName, value: $proposeViewModel.name)
                    .padding(.bottom)
                VStack(alignment: .leading, spacing: 0) {
                    Text(Strings.EN.DescriptionTitle + ":")
                        .modifier(TextSize14Bold())
                        .padding(.bottom, 3)
                    TextInputAutoHeight(text: $proposeViewModel.description, placeHolder: Strings.EN.DescriptionAdd)
                        .padding(.bottom)
                }
                
                HStack {
                    Text(Strings.EN.SelectPhotoTitle + ":")
                        .modifier(TextSize14Bold())
                        .padding(.bottom, 3)
                        .padding(.trailing, 10)
                    Button(action: {
                        showImagePicker()
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                }.padding(.bottom)
                
                ImageGridView(images: proposeViewModel.selectedImages, assets: proposeViewModel.selectedAsset)
                
                Button(action: {
                    proposeViewModel.sendRequest()
                }) {
                    MainButtonView(title: Strings.EN.SubmitTitle)
                }.padding(.top)
                
            }.listRowBackground(Color.clear)
            
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .listSeparatorStyle(.none)
        .navigationBarTitle(Text(Strings.EN.ProposeNavTitle))
        .modifier(DismissingKeyboard())
    }
    
    
    func showImagePicker() {
        self.viewControllerHolder.value?.present(style: .pageSheet)  {
            TLPhotoPickerView(currentAssets: proposeViewModel.selectedAsset, selectedAssets:  { assets in
                proposeViewModel.selectedAsset = assets
            })
        }
    }
}
