//
//  AddTemplateView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import SwiftUI
import SwiftUIListSeparator

struct AddTemplateView: View {
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @ObservedObject var addTemplateViewModel = AddTemplateViewModel()
    var body: some View {
        List {
            VStack(alignment: .leading) {
                MainTextField(title: Strings.EN.Name + ":", placeHolder: Strings.EN.PlaceHolderName, value: $addTemplateViewModel.name)
                    .padding(.bottom)
                VStack(alignment: .leading, spacing: 0) {
                    Text(Strings.EN.DescriptionTitle + ":")
                        .modifier(TextSize14Bold())
                        .padding(.bottom, 3)
                    TextInputAutoHeight(text: $addTemplateViewModel.description, placeHolder: Strings.EN.DescriptionAdd)
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
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                }
                if let image = addTemplateViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                }
                Button(action: {
                    addTemplateViewModel.addTemplate()
                }) {
                    MainButtonView(title: Strings.EN.AddTitle)
                }.padding(.top)
                
            }
        }
        .listSeparatorStyle(.none)
        .navigationBarTitle(Strings.EN.AddTemplateNavTitle)
    }
    
    func showImagePicker() {
        self.viewControllerHolder.value?.present(style: .fullScreen)  {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.addTemplateViewModel.selectedImage = image
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}


