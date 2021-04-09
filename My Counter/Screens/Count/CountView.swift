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
    @ObservedObject var countViewModel: CountViewModel
    init(template: TemplateServer) {
        self.countViewModel = CountViewModel(template: template)
    }
    
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
                    Text(countViewModel.template.description ?? "")
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
                        VStack(alignment: .leading) {
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
                            Text("\(Strings.EN.CountResultTitle)\(countViewModel.template.name ?? ""): \(countViewModel.countRespone?.count ?? 0)")
                                .bold()
                            Text("\(Strings.EN.SpentTime): \(countViewModel.spentTime) seconds")
                                .bold()
                            Text("\(Strings.EN.CountTime): \(countViewModel.countTime) seconds")
                                .bold()
                        }
                    }
                    
                    Button(action: {
                        countViewModel.start()

                    }, label: {
                        MainButtonView(title: countViewModel.selectedImage != nil ? Strings.EN.CountTitle: Strings.EN.SaveTitle)
                    })
                    .isHidden(self.countViewModel.selectedImage == nil && self.countViewModel.tempImage == nil)
                    .padding(.bottom)
                }
                .padding()
                .actionSheet(isPresented: $showActionSheet) {
                    sheet
                }
            }
            .navigationBarTitle(countViewModel.template.name ?? "")
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
