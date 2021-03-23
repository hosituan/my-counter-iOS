//
//  CountView.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 23/03/2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Alamofire
import ProgressHUD

struct CountView: View {
    @Environment(\.viewController) var viewControllerHolder: ViewControllerHolder
    @State var showActionSheet = false
    @ObservedObject var countViewModel = CountViewModel()
    let api = API()
    var template: Template
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Select image source"),
            buttons: [
                .default(Text("Take Photo"), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .camera
                    showImagePicker()
                }),
                .default(Text("Select from Library"), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .photoLibrary
                    showImagePicker()
                }),
                .cancel(Text("Close"), action: {
                    showActionSheet = false
                })
            ])
    }
    
    func showImagePicker() {
        self.viewControllerHolder.value?.present(style: .fullScreen)  {
            ImagePickerView(sourceType: countViewModel.sourceType) { image in
                self.countViewModel.selectedImage = image
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(template.description)
                        .bold()
                        .italic()
                        .font(.system(size: 14))
                        .padding(.bottom)
                    Button(action: {
                        showActionSheet = true
                        countViewModel.countRespone = nil
                    }, label: {
                        MainButtonView(title: self.countViewModel.selectedImage == nil ? "Select Photo" : "Change photo")
                    })
                    .padding(.bottom)
                    if let img = self.countViewModel.selectedImage {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .padding(.bottom)
                    }
                    
                    if let url = URL(string: countViewModel.countRespone?.url ?? "") {
                        VStack {
                            WebImage(url: url)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                                .padding(.bottom)
                            Text("Number of eggs: \(countViewModel.countRespone?.count ?? 0)")
                                .bold()
                        }
                    }
                    Button(action: {
                        if let img = countViewModel.selectedImage {
                            ProgressHUD.show("Counting...")
                            api.uploadImage(image: img, template: template) { result in
                                self.countViewModel.countRespone = result
                                ProgressHUD.dismiss()
                            }
                        }
                    }, label: {
                        MainButtonView(title: String.CountTitle)
                    })
                    .isHidden(self.countViewModel.selectedImage == nil)
                    .padding(.bottom)
                }
                .padding()
                .actionSheet(isPresented: $showActionSheet) {
                    sheet
                }
            }
            .navigationBarTitle(template.name)
        }
}

struct MainButtonView: View {
    var title = String.DefaultButtonTitle
    var backgroundColor = Color.blue
    var textColor = Color.white
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(height: 56)
                .cornerRadius(8)
            Text(title)
                .foregroundColor(textColor)
                .bold()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
