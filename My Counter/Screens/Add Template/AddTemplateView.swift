//
//  AddTemplateView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 31/03/2021.
//

import SwiftUI
import SwiftUIListSeparator


struct AddTemplateView: View {
    @ObservedObject var addTemplateViewModel = AddTemplateViewModel()
    @State var showSheet = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                MainTextField(title: Strings.EN.Name + ":", placeHolder: Strings.EN.PlaceHolderName, value: $addTemplateViewModel.name)
                    .padding(.bottom)
                MainTextField(title: Strings.EN.DriveID + ":", value: $addTemplateViewModel.driveID)
                    .padding(.bottom)
                VStack(alignment: .leading, spacing: 0) {
                    Text(Strings.EN.DescriptionTitle + ":")
                        .modifier(TextSize14Bold())
                        .padding(.bottom, 3)
                    TextInputAutoHeight(text: $addTemplateViewModel.description, placeHolder: Strings.EN.DescriptionAdd)
                        .padding(.bottom)
                }
                
                CheckView(isChecked: $addTemplateViewModel.isCircle, title: "Circle")
                    .padding(.bottom)
                CheckView(isChecked: $addTemplateViewModel.isSquare, title: "Square")
                
                HStack {
                    Text(Strings.EN.SelectPhotoTitle + ":")
                        .modifier(TextSize14Bold())
                        .padding(.bottom, 3)
                        .padding(.trailing, 10)
                    Button(action: {
                        showSheet = true
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .renderingMode(.original)
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
            .sheet(isPresented: $showSheet) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    self.addTemplateViewModel.selectedImage = image
                }
                .edgesIgnoringSafeArea(.all)
            }
            .padding(.horizontal)     
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.Count.TopBackgroundColor, Color.Count.BackgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarTitle(Strings.EN.AddTemplateNavTitle)
        .modifier(DismissingKeyboard())
    }

}


