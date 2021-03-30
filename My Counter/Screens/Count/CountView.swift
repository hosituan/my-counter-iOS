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
                .default(Text(Strings.TakePhoto), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .camera
                    showImagePicker()
                }),
                .default(Text(Strings.SelectFromLibrary), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .photoLibrary
                    showImagePicker()
                }),
                .cancel(Text(Strings.CancelTitle), action: {
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
                        MainButtonView(title: self.countViewModel.selectedImage == nil ? Strings.SelectPhotoTitle : Strings.ChangePhotoTitle)
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
                            Text("\(Strings.CountResultTitle): \(countViewModel.countRespone?.count ?? 0)")
                                .bold()
                        }
                    }
                    
                    CheckView(isChecked: $countViewModel.isDefault, title: Strings.DefaultMethodTitle)
                        .padding(.vertical)
                    Button(action: {
                        if let img = countViewModel.selectedImage {
                            ProgressHUD.show(Strings.Counting)
                            api.uploadForCounting(image: img, template: template, method: countViewModel.method) { result in
                                self.countViewModel.countRespone = result
                                ProgressHUD.dismiss()
                            }
                        }
                    }, label: {
                        MainButtonView(title: Strings.CountTitle)
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


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
