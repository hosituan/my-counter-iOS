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
    var template: TemplateServer
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Select image source"),
            buttons: [
                .default(Text(Strings.EN.TakePhoto), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .camera
                    showImagePicker()
                }),
                .default(Text(Strings.EN.SelectFromLibrary), action: {
                    showActionSheet = false
                    countViewModel.sourceType = .photoLibrary
                    showImagePicker()
                }),
                .cancel(Text(Strings.EN.CancelTitle), action: {
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
                    Text(template.description ?? "")
                        .bold()
                        .italic()
                        .font(.system(size: 14))
                        .padding(.bottom)
                    Button(action: {
                        AppDelegate.shared().requestCameraAccess() { result in
                            if result {
                                showActionSheet = true
                                countViewModel.countRespone = nil
                            }
                        }
       
                    }, label: {
                        MainButtonView(title: self.countViewModel.selectedImage == nil ? Strings.EN.SelectPhotoTitle : Strings.EN.ChangePhotoTitle)
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
                                .placeholder(content: {
                                    Image(uiImage: countViewModel.tempImage!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(8)
                                })
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(8)
                                .padding(.bottom)
                            Text("\(Strings.EN.CountResultTitle)\(template.name ?? ""): \(countViewModel.countRespone?.count ?? 0)")
                                .bold()
                        }
                    }
                    
                    CheckView(isChecked: $countViewModel.isDefault, title: Strings.EN.DefaultMethodTitle)
                        .padding(.vertical)
                    Button(action: {
                        if let img = countViewModel.selectedImage {
                            ProgressHUD.show(Strings.EN.Counting)
                            api.uploadForCounting(image: img, template: template, method: countViewModel.method) { result in
                                self.countViewModel.countRespone = result
                                ProgressHUD.dismiss()
                            }
                        }
                    }, label: {
                        MainButtonView(title: Strings.EN.CountTitle)
                    })
                    .isHidden(self.countViewModel.selectedImage == nil && self.countViewModel.tempImage == nil)
                    .padding(.bottom)
                }
                .padding()
                .actionSheet(isPresented: $showActionSheet) {
                    sheet
                }
            }
            .navigationBarTitle(template.name ?? "")
            .onDisappear() {
                countViewModel.selectedImage = nil
                countViewModel.countRespone = nil
                countViewModel.tempImage = nil
            }
        }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
