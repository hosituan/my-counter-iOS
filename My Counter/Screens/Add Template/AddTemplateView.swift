//
//  AddTemplateView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import SwiftUI

struct AddTemplateView: View {
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @ObservedObject var addTemplateViewModel = AddTemplateViewModel()
    var body: some View {
            VStack(alignment: .leading) {
                MainTextField(title: "Name:", placeHolder: "Chicken Egg", value: $addTemplateViewModel.name)
                    .padding(.bottom)
                MainTextField(title: "Description:", placeHolder: "What about it?", value: $addTemplateViewModel.description)
                    .padding(.bottom)
                HStack {
                    Text(Strings.EN.SelectPhotoTitle + " :")
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
                Image(uiImage: addTemplateViewModel.selectedImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical)
                Button(action: {
                    addTemplateViewModel.addTemplate()
                }) {
                    MainButtonView(title: "Add")
                }
                
            }
        .alert(isPresented: $addTemplateViewModel.showAlert, content: {
            Alert(title: Text(addTemplateViewModel.alertTitle), message: Text(addTemplateViewModel.alertMessage), dismissButton: .default(Text(Strings.EN.OkTitle)))
        })
        .padding(.horizontal, 16)
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


